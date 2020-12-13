// CODEPIPELINE POLICY
resource "aws_iam_role" "codepipeline_iam_role" {
  name               = "${var.project_name}_codepipeline_role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

// policy definition
resource "aws_iam_policy" "codepipeline_default_iam_policy" {
  name   = "default_iam_policy"
  policy = data.aws_iam_policy_document.codepipeline_default_iam_policy_document.json
}

// policy description
data "aws_iam_policy_document" "codepipeline_default_iam_policy_document" {
  statement {
    sid = ""

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole"
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

// policy attachment
resource "aws_iam_role_policy_attachment" "codepipeline_default_iam_role_policy" {
  role       = join("", aws_iam_role.codepipeline_iam_role.*.id)
  policy_arn = join("", aws_iam_policy.codepipeline_default_iam_policy.*.arn)
}

// S3 POLICY

// policy definition
resource "aws_iam_policy" "s3_iam_policy" {
  name   = "codepipeline_s3_policy_label"
  policy = join("", data.aws_iam_policy_document.s3_iam_policy_document.*.json)
}

//policy description
data "aws_iam_policy_document" "s3_iam_policy_document" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]

    resources = [
      join("", aws_s3_bucket.default_s3_bucket.*.arn),
      "${join("", aws_s3_bucket.default_s3_bucket.*.arn)}/*"
    ]

    effect = "Allow"
  }
}

// policy attachment
resource "aws_iam_role_policy_attachment" "s3_iam_role_policy" {
  role       = join("", aws_iam_role.codepipeline_iam_role.*.id)
  policy_arn = join("", aws_iam_policy.s3_iam_policy.*.arn)
}


// CODEBUILD POLICY
// policy description
resource "aws_iam_policy" "codebuild" {
  name   = "codebuild_label"
  policy = data.aws_iam_policy_document.codebuild_iam_policy_document.json
}

// policy definition
data "aws_iam_policy_document" "codebuild_iam_policy_document" {
  statement {
    sid = ""

    actions = [
      "codebuild:*"
    ]

    resources = [module.codebuild.project_id]
    effect    = "Allow"
  }
}

// policy attachment
resource "aws_iam_role_policy_attachment" "codebuild_iam_role_policy" {
  role       = join("", aws_iam_role.codepipeline_iam_role.*.id)
  policy_arn = join("", aws_iam_policy.codebuild.*.arn)
}

resource "aws_iam_role_policy_attachment" "codebuild_s3_iam_role_policy" {
  role       = module.codebuild.role_id
  policy_arn = join("", aws_iam_policy.s3_iam_policy.*.arn)
}