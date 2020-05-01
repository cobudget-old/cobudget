# Cobudget AWS CDK Deployment Scripts

This directory contains three stacks that interoperate.

## The Pipeline Stack

This stack describes:

1. A GitHub repository where a hook is installed.
1. ECR repository that hosts the Docker containers.
1. A build pipeline that builds a Docker container from source and publishes it to ECR.

## The Backend Stack

This stack describes:

1. A Fargate service that hosts the Docker container and postgres RDS
1. A frontend stack that hosts the static web app files
1. A pipeline stack that defines the CI/CD system that deploys the code automatically


SSM Variables must be set before standing up a new stack 

```

aws secretsmanager create-secret \
    --name GitHubToken \
    --secret-string abcdefg1234abcdefg56789abcdefg \
    --region us-east-1

aws ssm put-parameter \
    --name /serverless-pipeline/sns/notifications/primary-email \
    --description "Email address for primary recipient of Pipeline notifications" \
    --type String \
    --value PRIMARY_EMAIL_ADDRESS

aws ssm put-parameter \
    --name /serverless-pipeline/codepipeline/github/repo \
    --description "Github Repository name for CloudFormation Stack serverless-pipeline" \
    --type String \
    --value GITHUB_REPO_NAME

aws ssm put-parameter \
    --name /serverless-pipeline/codepipeline/github/user \
    --description "Github Username for CloudFormation Stack serverless-pipeline" \
    --type String \
    --value GITHUB_USER

aws secretsmanager create-secret \
    --name /serverless-pipeline/secrets/github/token \
    --secret-string '{"github-token":"YOUR_TOKEN"}'
```

The `cdk.json` file tells the CDK Toolkit how to execute your app.

## Useful commands

 * `npm run build`   compile typescript to js
 * `npm run watch`   watch for changes and compile
 * `npm run test`    perform the jest unit tests
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk synth`       emits the synthesized CloudFormation template
