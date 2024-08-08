# modules/lambda_deployment/variables.tf

variable "lambda_name" {
  description = "The name of the Lambda function to be created."
  type        = string
}

variable "stage" {
  description = "The stage of the deployment (e.g., dev, prod)."
  type        = string
}

variable "bitbucket_repo_url" {
  description = "The Bitbucket repository URL."
  type        = string
}

variable "buildspec_file" {
  description = "The path to the buildspec.yml file."
  type        = string
}

variable "bitbucket_connection_arn" {
  description = "The ARN of the Bitbucket OAuth connection in AWS."
  type        = string
}

variable "source_version" {
  description = "The branch or tag to use from the repository."
  type        = string
  default     = "main"
}

