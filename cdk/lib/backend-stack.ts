import * as cdk from '@aws-cdk/core';
import ec2 = require('@aws-cdk/aws-ec2');
import ecs = require('@aws-cdk/aws-ecs');
import ecs_patterns = require('@aws-cdk/aws-ecs-patterns');

export class CobudgetBackendStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, "CobudgetVpc", {
      maxAzs: 3 // Default is all AZs in region
    });
    const cluster = new ecs.Cluster(this, "CobudgetCluster", {
      vpc: vpc
    });
    // Create a load-balanced Fargate service and make it public
    new ecs_patterns.ApplicationLoadBalancedFargateService(this, "CobudgetFargateService", {
      cluster: cluster,
      cpu: 512,
      desiredCount: 1,
      taskImageOptions: {
        image: ecs.ContainerImage.fromRegistry("gardner/cobudget"),
        containerPort: 3000
      },
      memoryLimitMiB: 2048,
      publicLoadBalancer: true // Default is false
    });
  }
}
