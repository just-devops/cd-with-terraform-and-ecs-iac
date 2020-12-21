terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.14"
}

resource "aws_s3_bucket" "default_s3_bucket" {
  bucket        = "${var.project_name_for_aws}-codepipeline-bucket"
  acl           = "private"
  force_destroy = true

}

data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "dockerhub"
}

data "aws_secretsmanager_secret_version" "github_access_token" {
  # Fill in the name you gave to your secret
  secret_id = "github_token"
}

module "codebuild" {
  source             = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=tags/0.26.0"
  namespace          = "webapp"
  stage              = "test"
  name               = "${var.project_name}_codebuild"
  privileged_mode    = true
  aws_region         = var.aws_region
  image_repo_name    = var.image_repo_name
  github_token       = var.github_access_token
  aws_account_id     = var.aws_account_id
  build_image        = var.build_image
  build_compute_type = var.build_compute_type
  build_timeout      = 60
  extra_permissions  = ["ecr:BatchGetImage"]
}

resource "aws_codepipeline" "tf_aws_pipeline" {
  name     = "tf_aws_pipeline"
  role_arn = aws_iam_role.codepipeline_iam_role.arn

  artifact_store {
    location = aws_s3_bucket.default_s3_bucket.bucket
    type     = "S3"
  }

  depends_on = [
    aws_iam_role_policy_attachment.codebuild_iam_role_policy,
    aws_iam_role_policy_attachment.codebuild_s3_iam_role_policy,
    aws_iam_role_policy_attachment.codepipeline_default_iam_role_policy,
    aws_iam_role_policy_attachment.s3_iam_role_policy,
  ]


  stage {
    name = "SourceCode"

    action {
      category         = "Source"
      name             = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_code_output"]

      configuration = {
        OAuthToken           = var.github_access_token
        Owner                = var.repo_owner
        Repo                 = var.repo_name
        Branch               = var.repo_branch
        PollForSourceChanges = var.poll_source_changes
      }
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      name     = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["source_code_output"]
      output_artifacts = ["task"]

      configuration = {
        ProjectName = module.codebuild.project_name
      }
    }
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.image_repo_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.keep_tagged_last_n_images} images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${join("\",\"", ["v"])}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.keep_tagged_last_n_images}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Expire images older than ${var.expire_untagged_older_than_n_days} days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.expire_untagged_older_than_n_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
