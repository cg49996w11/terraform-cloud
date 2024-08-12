
# Deploy lambda using serverless framework

This project is used for deploying  lambda functions using serverless framework. It uses AWS codebuild with a webhook pointing to the bitbucket repository that is triggered every time pull request is merged.AWS codebuild is used to transpile the typescript to javascript and then deploy it using serverless framework across multiple environments


## Usage

Package.json

This file is used to install necessary dependencies in aws codebuild execution environment.
```bash
{
  "name": "my-lambda-project",
  "version": "1.0.0",
  "description": "A simple TypeScript AWS Lambda function",
  "main": "dist/handler.js",
  "scripts": {
    "build": "tsc",
    "deploy": "serverless deploy",
    "start": "serverless offline"
  },
  "dependencies": {
    "aws-lambda": "^1.0.6"
  },
  "devDependencies": {
    "@types/aws-lambda": "^8.10.92",
    "serverless": "^3.0.0",
    "serverless-offline": "^8.0.0",
    "typescript": "^4.0.0"
  }
}


```

Buildspec.yaml


It is the file used by AWS codebuild.It will run all 4 phases defined in it

1)Install phase
* npm install :Install phase is used to install all dependencies that are defined in package.json file
* npm install -g serverless: Install serverless framework

2)pre_build phase
* npm run build: It will run the "build" script defined in package.json. We can see from  package.json that this will run tsc command without any filenames.This step will transpile typescript code src/handler.ts to javascript code using compilation options defined in tsconfig.json

3)Build phase
* serverless deploy --stage $STAGE
This will deploy the lamda function in $STAGE environment by referencing the configuration defined in serverless.yml. It picks this value from STAGE environment variable that we pass to terraform in main.tf.


```bash
version: 0.2

phases:
  install:
    commands:
      - echo "Installing dependencies..."
      - npm install
      - npm install -g serverless
  pre_build:
    commands:
      - echo "Building the project..."
      - npm run build
  build:
    commands:
      - echo "Deploying to AWS..."
      - serverless deploy --stage $STAGE
  post_build:
    commands:
      - echo "Deployment complete."
artifacts:
  files:
    - '**/*'


```

serverless.yml

* Update service property, the value defined here will be the name of lambda function
* Update functions property with the name of handler that you defined in typescript as the same handler will be transpile to javascript in dist folder while running npm run build
* serverless-offline is a plugin used for local testing and custom is used to pass any custom configurations for local debugging


```bash
service: my-lambda-project

provider:
  name: aws
  runtime: nodejs18.x
  region: us-east-1

functions:
  helloWorld:
    handler: dist/handler.helloWorld
    events:
      - http:
          path: hello
          method: get

plugins:
  - serverless-offline

package:
  individually: true

custom:
  stage: ${opt:stage, 'dev'}




```









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
* The bitbucket_repo_url will point to repository where you intend to configure the webhook , the source_version will the branch for the same and bitbucket_connection_arn will be arn for same

* The stage will point to the environment where you intend to deploy the lambda
The source_version

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
