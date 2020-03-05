import * as cdk from '@aws-cdk/core';
import { CloudFrontWebDistribution } from '@aws-cdk/aws-cloudfront';
import { Bucket, HttpMethods } from '@aws-cdk/aws-s3';

export class CobudgetFrontendStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // S3
    const sourceBucket = new Bucket(this, 'CobudgetBucket', {
      bucketName: 'gardner.cobudget.co',
      websiteErrorDocument: 'index.html',
      websiteIndexDocument: 'index.html',
      publicReadAccess: true,
      cors: [
          {
              allowedOrigins: ['*'],
              allowedMethods: [HttpMethods.GET],
          }
      ]
    });

    // CloudFormation
    const distribution = new CloudFrontWebDistribution(this, 'CobudgetDistribution', {
      originConfigs: [
        {
          s3OriginSource: {
            s3BucketSource: sourceBucket
          },
          behaviors: [{
            isDefaultBehavior: true
          }]
        }
      ]
    });
  };
}
