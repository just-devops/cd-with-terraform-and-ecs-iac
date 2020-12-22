#### REQUIRED

variable "aws_region" {
  type        = string
  description = "your preferred aws region"
}

variable "profile" {
  type        = string
  description = "your aws profile"
}

variable "github_access_token" {
  type        = string
  description = "the token"
}

variable "repo_owner" {
  type        = string
  description = "your github organisation"
}

variable "repo_name" {
  type        = string
  description = "your github repo"
}

variable "cluster_name" {
  type        = string
  description = "your ecs cluster name"
}

variable "app_service_name" {
  type        = string
  description = "your ecs service name"
}

#### REST

variable "project_name" {
  type    = string
  default = "tf_ecs_continuous_deployment"
}

variable "project_name_for_aws" {
  type    = string
  default = "tf-ecs-continuous-deployment"
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
  default     = "react-webapp"
  description = "ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository.Must be one of MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"
}

variable "keep_tagged_last_n_images" {
  description = "Keeps only n number of images in the repository."
  type        = number
  default     = 30
}

variable "expire_untagged_older_than_n_days" {
  description = "Deletes untagged images older than n days."
  type        = number
  default     = 15
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
