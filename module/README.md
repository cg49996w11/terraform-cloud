
# Deploy lambda using serverless framework

This project is used for deploying  lambda functions using serverless framework. Terraform is used to create AWS codebuild instance with a webhook pointing to the bitbucket repository that is triggered every time pull request is merged.AWS codebuild is used to transpile the typescript to javascript and then deploy it to create aws-lambda using serverless framework

## Deployment

To deploy this project run

 1) Update lambda_name,stage ,bitbucket_repo_url,   source_version,bitbucket_connection_arn values in main.tf
```bash
  source                  = "./modules/lambda_deployment"
  lambda_name             = "my-first-lambda"
  stage                   = "dev"
  bitbucket_repo_url      = "https://bitbucket.org/your-workspace/first-lambda-repo.git"
  buildspec_file          = "buildspec.yml"
  bitbucket_connection_arn = "arn:aws:codestar-connections:us-east-1:123456789012:connection/your-connection-id"
  source_version          = "main"


```
*The bitbucket_repo_url will point to repository where you intend to configure the webhook , the source_version will the branch for the repository and bitbucket_connection_arn will be arn for same

*The stage will point to the environment where you intend to deploy the lambda


2) Make sure you are in modules directory and then run 
```bash
terraform init
```

3) Run 
```bash
terraform plan
```

2) Validate the above plan and then run  
```bash
terraform apply
```