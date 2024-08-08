# modules/lambda_deployment/outputs.tf

output "codebuild_project_name" {
  description = "The name of the CodeBuild project."
  value       = aws_codebuild_project.serverless_deploy.name
}

