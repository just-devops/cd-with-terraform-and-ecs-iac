resource "aws_s3_bucket" "default_s3_bucket" {
  bucket        = "${var.project_name_for_aws}-codepipeline-bucket"
  acl           = "private"
  force_destroy = true

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