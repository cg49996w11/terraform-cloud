provider "aws" {
  region = "us-east-1"
}

module "lambda_deployment_1" {
  source                  = "./modules/lambda_deployment"
  lambda_name             = "my-first-lambda"
  stage                   = "dev"
  bitbucket_repo_url      = "https://bitbucket.org/your-workspace/first-lambda-repo.git"
  buildspec_file          = "buildspec.yml"
  bitbucket_connection_arn = "arn:aws:codestar-connections:us-east-1:123456789012:connection/your-connection-id"
  source_version          = "main"
}

output "first_lambda_codebuild_project" {
  value = module.lambda_deployment_1.codebuild_project_name
}
