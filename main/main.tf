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

module "codepipeline" {
  source              = "./modules/codepipeline"
  aws_region          = var.aws_region
  profile             = var.profile
  repo_owner          = var.repo_owner
  github_access_token = var.github_access_token
  repo_name           = var.repo_name
}