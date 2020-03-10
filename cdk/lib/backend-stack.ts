import * as cdk from '@aws-cdk/core';
import ec2 = require('@aws-cdk/aws-ec2');
import ecs = require('@aws-cdk/aws-ecs');
import ecr = require('@aws-cdk/aws-ecr');

import ecs_patterns = require('@aws-cdk/aws-ecs-patterns');
import ssm = require('@aws-cdk/aws-ssm');

const domainName = 'cobudget.xyz';

function getSecret(stack: cdk.Stack, key: string): ecs.Secret {
  return ecs.Secret.fromSsmParameter(
    ssm.StringParameter.fromStringParameterName(stack, key, `/${key}`)
  )
}

export class CobudgetBackendStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, "CobudgetVpc", {
      maxAzs: 3 // Default is all AZs in region
    });
    const cluster = new ecs.Cluster(this, "CobudgetCluster", {
      vpc: vpc
    });

    const ecrRepository = new ecr.Repository(this, 'cobudget');

    // Create a load-balanced Fargate service and make it public
    new ecs_patterns.ApplicationLoadBalancedFargateService(this, "CobudgetFargateService", {
      cluster: cluster,
      cpu: 256,
      desiredCount: 1,
      taskImageOptions: {
        image: ecs.ContainerImage.fromEcrRepository(ecrRepository),
        secrets: {
          SMTP_PASSWORD: getSecret(this, 'SMTP_PASSWORD'),
          SECRET_KEY_BASE: getSecret(this, 'SECRET_KEY_BASE'),
          DATABASE_URL: getSecret(this, 'DATABASE_URL')
        },
        environment: {
          CANONICAL_HOST: domainName,
          DEVOPS_MAIL: "devops@greaterthan.finance",
          RAILS_ENV: "production",
          RACK_ENV: "production",
          SMTP_DOMAIN: "cobudget.co",
          SMTP_PORT: "587",
          SMTP_SERVER: "smtp.sendgrid.net",
          SMTP_USERNAME: "apikey"
    
        },
        containerName: 'cobudget-api-container',
        containerPort: 3000
      },
      memoryLimitMiB: 1024,
      publicLoadBalancer: true // Default is false
    });
  }
}
