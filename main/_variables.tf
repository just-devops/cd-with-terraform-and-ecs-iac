#### AWS

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "aws-devops"
}

#### VPC

# Customize the Cluster Name
variable "cluster_name" {
  description = "ECS Cluster Name"
  default     = "web-app"
}

#### ECS

variable "container_name" {
  type    = string
  default = "web-app"
}

variable "image_repo_name" {
  type    = string
  default = "web-app"
}

#### CODEPIPELINE

variable "repo_owner" {
  type    = string
  default = "just-devops"
}

variable "repo_name" {
  type    = string
  default = "react-codebuild"
}
