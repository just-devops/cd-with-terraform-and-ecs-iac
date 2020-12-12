provider "aws" {
  region = "us-east-1"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "ssh_key_private" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "ssh_key_public" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "tf_ecs_continuous_deployment"
}

variable "project_name_for_aws" {
  type    = string
  default = "tf-ecs-continuous-deployment"
}

variable "github_access_token" {
  type    = string
  default = "8eca665407425cd5d0aed0a10962d1354c30ee1a"
}

variable "repo_owner" {
  type    = string
  default = "paschalidi"
}

variable "repo_name" {
  type    = string
  default = "wh-questions-game"
}

variable "repo_branch" {
  type    = string
  default = "master"
}

# https://www.terraform.io/docs/configuration/variables.html
# It is recommended you avoid using boolean values and use explicit strings
variable "poll_source_changes" {
  type        = bool
  default     = false
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

variable "image_repo_name" {
  type        = string
  default     = "image-repo-tf-ecs-continuous-deployment"
  description = "ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "image_tag" {
  type        = string
  default     = "latest"
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}