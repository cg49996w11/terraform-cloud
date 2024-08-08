# modules/lambda_deployment/main.tf

resource "aws_iam_role" "codebuild_role" {
  name = "${var.lambda_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "lambda:*",
          "cloudformation:*",
          "logs:*",
          "iam:PassRole",
          "apigateway:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "serverless_deploy" {
  name          = "${var.lambda_name}-serverless-deploy"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "STAGE"
      value = var.stage
    }
  }

  source {
    type      = "BITBUCKET"
    location  = var.bitbucket_repo_url
    buildspec = var.buildspec_file
    auth {
      type         = "OAUTH"
      resource_arn = var.bitbucket_connection_arn
    }
  }

  source_version = var.source_version
}

resource "aws_codebuild_webhook" "serverless_deploy_webhook" {
  project_name = aws_codebuild_project.serverless_deploy.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_MERGED"
    }
  }
}

output "codebuild_project_name" {
  value = aws_codebuild_project.serverless_deploy.name
}

