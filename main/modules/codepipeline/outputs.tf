output "tf_aws_pipeline_name" {
  description = "the name of the aws pipeline created"
  value       = aws_codepipeline.tf_aws_pipeline.name
  sensitive   = true
}
