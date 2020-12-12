terraform {
  required_version = ">=0.13"
  backend "s3" {
    region  = "us-east-1"
    profile = "aws-devops"
    key     = "tf-ecs-continuous-deployment"
    bucket  = "tf-ecs-continuous-deployment"
  }
}