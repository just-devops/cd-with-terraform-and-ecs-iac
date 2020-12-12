resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}_codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project_name}_codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.default.arn}",
        "${aws_s3_bucket.default.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "default" {
  bucket = "${var.project_name_for_aws}-codepipeline-bucket"
  acl    = "private"
  force_destroy = true

}

module "codebuild" {
  source          = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=tags/0.26.0"
  namespace       = "webapp"
  stage           = "test"
  name            = "${var.project_name}_codebuild"
  privileged_mode = false
  aws_region      = var.aws_region
  image_repo_name = var.image_repo_name
  image_tag       = var.image_tag
  github_token    = var.github_access_token

  # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
  build_image        = "aws/codebuild/standard:4.0"
  build_compute_type = "BUILD_GENERAL1_SMALL"
  build_timeout      = 60
}

resource "aws_codepipeline" "tf_aws_pipeline" {
  name     = "tf_aws_pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.default.bucket
    type     = "S3"
  }

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