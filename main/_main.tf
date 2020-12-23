terraform {
  required_version = ">=0.12"
  backend "s3" {
    region  = "us-east-1"
    profile = "aws-devops"
    key     = "tf-fargate-ecs-continuous-deployment"
    bucket  = "tf-fargate-ecs-continuous-deployment"
  }
}

provider "aws" {
  region = var.aws_region
}

#### SSM

data "aws_secretsmanager_secret" "by-arn" {
  arn = "arn:aws:secretsmanager:us-east-1:043372837203:secret:tf_gh_token-v8tQ4j"
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.by-arn.id
}

locals {
  github_token = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["token"]
}

#### VPC

module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
}

module "elb" {
  source                 = "./modules/elb"
  vpc                    = module.vpc.vpc
  load_balancer_sg       = module.vpc.alb_sg_id
  load_balancer_subnet_a = module.vpc.load_balancer_subnet_a_id
  load_balancer_subnet_b = module.vpc.load_balancer_subnet_b_id
  load_balancer_subnet_c = module.vpc.load_balancer_subnet_c_id
}

module "iam" {
  source = "./modules/elb-iam"
  elb    = module.elb.elb_name
}

module "ecs" {
  source           = "./modules/ecs"
  ecs_role         = module.iam.ecs_role
  ecs_sg_id        = module.vpc.ecs_sg_id
  ecs_subnet_a     = module.vpc.ecs_subnet_a
  ecs_subnet_b     = module.vpc.ecs_subnet_b
  ecs_subnet_c     = module.vpc.ecs_subnet_c
  ecs_target_group = module.elb.ecs_target_group

  cluster_name        = var.cluster_name
  container_name      = var.container_name
  image_repo_name     = var.image_repo_name
  container_port      = 80
  desired_task_cpu    = 512
  desired_task_memory = 1024
}

module "auto_scaling" {
  source      = "./modules/autoscaling"
  ecs_cluster = module.ecs.ecs_cluster
  ecs_service = module.ecs.ecs_service
}

module "codepipeline" {
  source              = "./modules/codepipeline"
  app_service_name    = module.ecs.ecs_service_name
  profile             = var.profile
  aws_region          = var.aws_region
  repo_owner          = var.repo_owner
  github_access_token = var.access_token
  repo_name           = var.repo_name
  cluster_name        = var.cluster_name
  image_repo_name     = var.image_repo_name
}
