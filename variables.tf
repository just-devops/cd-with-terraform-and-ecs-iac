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
  default = "react-codebuild"
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
  default     = "tf-ecs-continuous-deployment"
  description = "ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/standard:4.0"
  description = "Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0`"
}

variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "`CodeBuild` instance size. Possible values are: `BUILD_GENERAL1_SMALL` `BUILD_GENERAL1_MEDIUM` `BUILD_GENERAL1_LARGE`"
}
