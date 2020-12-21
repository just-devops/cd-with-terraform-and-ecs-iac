variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "repo_owner" {
  type    = string
  default = "just-devops"
}

variable "repo_name" {
  type    = string
  default = "react-codebuild"
}

variable "ssh_key_private" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "ssh_key_public" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

