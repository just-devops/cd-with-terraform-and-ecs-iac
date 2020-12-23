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

#### CODEPIPELINE

variable "repo_owner" {
  type    = string
  default = "just-devops"
}

variable "repo_name" {
  type    = string
  default = "react-codebuild"
}

#### TO REMOVE

variable "access_token" {
  type    = string
  default = "d742f10cbda6a9b528649a99ba0ba186311751a7"
}

#### ECS-DYNAMIC

variable "container_name" {
  type    = string
  default = "react-nginx-container"
}

variable "image_repo_name" {
  type    = string
  default = "react-nginx"
}