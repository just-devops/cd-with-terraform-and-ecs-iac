
resource "random_string" "webhook_secret" {
  length = 32

  # Special characters are not allowed in webhook secret (AWS silently ignores webhook callbacks)
  special = false
}

locals {
  webhook_secret = join("", random_string.webhook_secret.*.result)
  webhook_url    = join("", aws_codepipeline_webhook.webhook.*.url)
}

variable "webhook_filter_json_path" {
  type        = string
  description = "The JSON path to filter on"
  default     = "$.ref"
}

variable "webhook_filter_match_equals" {
  type        = string
  description = "The value to match on (e.g. refs/heads/{Branch})"
  default     = "refs/heads/{Branch}"
}
resource "aws_codepipeline_webhook" "webhook" {
  name            = "codepipeline_webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = join("", aws_codepipeline.tf_aws_pipeline.*.name)

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = var.webhook_filter_json_path
    match_equals = var.webhook_filter_match_equals
  }
}

module "github_webhooks" {
  source               = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git?ref=tags/0.10.0"
  github_anonymous     = false
  github_organization  = var.github_organisation
  github_repositories  = [var.repo_name]
  github_token         = var.github_access_token
  webhook_url          = local.webhook_url
  webhook_secret       = local.webhook_secret
  webhook_content_type = "json"
  events               = ["push"]
}