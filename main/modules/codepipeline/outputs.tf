output "tf_aws_pipeline_name" {
  description = "the name of the aws pipeline created"
  value       = aws_codepipeline.tf_aws_pipeline.name
  sensitive   = true
}

output "image_latest" {
  value = "${aws_ecr_repository.ecr_repo.registry_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.ecr_repo.name}:latest"
}
