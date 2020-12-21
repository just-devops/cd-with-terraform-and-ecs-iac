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
  region = "us-east-1"
}

data "aws_secretsmanager_secret" "by-arn" {
  arn = "arn:aws:secretsmanager:us-east-1:043372837203:secret:tf_gh_token-v8tQ4j"
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.by-arn.id
}

locals {
  github_token = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["token"]
}

module "codepipeline" {
  source              = "./modules/codepipeline"
  aws_region          = var.aws_region
  profile             = var.profile
  repo_owner          = var.repo_owner
  github_access_token = local.github_token
  repo_name           = var.repo_name
}