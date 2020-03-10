import * as cdk from '@aws-cdk/core';
const rds = require('@aws-cdk/aws-rds');
const secretsManager = require('@aws-cdk/aws-secretsmanager');
const ssm = require('@aws-cdk/aws-ssm');

export const getParams = (stack: cdk.Stack, params: Array<string>) => {
  // Retrieve a specific version of the secret (SecureString) parameter.
  // 'version' is always required.
  return params.filter((value, index, array) => {
    return ssm.StringParameter.fromSecureStringParameterAttributes(stack, value, {
      parameterName: `/${value}`,
      version: 1
    });  
  });
}

// Store secrets from local environment variables.
// dot notation intentionally used to cause a failure when no value is present
export const createSecrets = ({serviceName, stage, stack, region, account}) => {

  const databaseCredentialsSecret = new secretsManager.Secret(stack, 'DBCredentialsSecret', {
    secretName: `${serviceName}-${stage}-credentials`,
    generateSecretString: {
      secretStringTemplate: JSON.stringify({
        DATABASE_URL: process.env.DATABASE_URL,
        SECRET_KEY_BASE: process.env.SECRET_KEY_BASE,
        SMTP_PASSWORD: process.env.SMTP_PASSWORD
      }),
      excludePunctuation: true,
      includeSpace: false,
      generateStringKey: 'password'
    }
  });

  new ssm.StringParameter(stack, 'DBCredentialsArn', {
    parameterName: `${serviceName}-${stage}-credentials-arn`,
    stringValue: databaseCredentialsSecret.secretArn,
  });

  const isDev = stage !== "production";
  const dbConfig = {
    dbClusterIdentifier: `main-${serviceName}-${stage}-cluster`,
    engineMode: 'serverless',
    engine: 'aurora-postgresql',
    engineVersion: '10.7',
    enableHttpEndpoint: true,
    databaseName: 'main',
    masterUsername: databaseCredentialsSecret.secretValueFromJson('username').toString(),
    masterUserPassword: databaseCredentialsSecret.secretValueFromJson('password'),
    backupRetentionPeriod: isDev ? 1 : 30,
    finalSnapshotIdentifier: `main-${serviceName}-${stage}-snapshot`,
    scalingConfiguration: {
      autoPause: true,
      maxCapacity: isDev ? 4 : 384,
      minCapacity: 2,
      secondsUntilAutoPause: isDev ? 3600 : 10800,
    }
  };

  const rdsCluster = new rds.CfnDBCluster(stack, 'DBCluster', dbConfig,
    deletionProtection: isDev ? false : true,
    });

const dbClusterArn = `arn:aws:rds:${region}:${account}:cluster:${rdsCluster.ref}`;

new ssm.StringParameter(stack, 'DBResourceArn', {
  parameterName: `${serviceName}-${stage}-resource-arn`,
  stringValue: dbClusterArn,
});
  }

