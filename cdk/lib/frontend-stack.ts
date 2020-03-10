import * as cdk from '@aws-cdk/core';
import { CloudFrontWebDistribution, ViewerCertificate } from '@aws-cdk/aws-cloudfront';
import { HttpsRedirect } from '@aws-cdk/aws-route53-patterns';
import { HostedZone } from '@aws-cdk/aws-route53'
import { Bucket, HttpMethods } from '@aws-cdk/aws-s3';

const domainName = 'cobudget.xyz';
const hostedZoneId = 'ZRG3Z2GKCQIHJ';

export class CobudgetFrontendStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Route53 https redirect creats an ACM cert
    // @see https://github.com/aws/aws-cdk/blob/db111afe25a24d259a08a29b7530afbbebc39351/packages/%40aws-cdk/aws-route53-patterns/lib/website-redirect.ts#L36
    // const redirect = new HttpsRedirect(this, 'Redirect', {
    //   recordNames: [domainName, `www.${domainName}`],
    //   targetDomain: domainName,
    //   zone: HostedZone.fromHostedZoneAttributes(this, 'HostedZone', {
    //     hostedZoneId: hostedZoneId,
    //     zoneName: domainName,
    //   })
    // });

    // S3
    // const sourceBucket = new Bucket(this, 'CobudgetBucket', {
    //   bucketName: domainName,
    //   websiteErrorDocument: 'index.html',
    //   websiteIndexDocument: 'index.html',
    //   publicReadAccess: true,
    //   cors: [
    //       {
    //           allowedOrigins: ['*'],
    //           allowedMethods: [HttpMethods.GET],
    //       }
    //   ]
    // });

    const bucket = Bucket.fromBucketAttributes(this, 'ImportedBucket', {
      bucketArn: `arn:aws:s3:::${domainName}`
    });

    // CloudFormation
    const distribution = new CloudFrontWebDistribution(this, 'CobudgetDistribution', {
      originConfigs: [
        {
          s3OriginSource: {
            s3BucketSource: bucket
          },
          behaviors: [{
            isDefaultBehavior: true
          }]
        }
      ],
      viewerCertificate: ViewerCertificate.fromCloudFrontDefaultCertificate(
        'cobudget.xyz'
      ),      
    });
  };
}
