#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CobudgetBackendStack } from '../lib/backend-stack';
import { CobudgetFrontendStack } from '../lib/frontend-stack';

const app = new cdk.App();
const backend = new CobudgetBackendStack(app, 'CobudgetBackendStack');
const frontend = new CobudgetFrontendStack(app, 'CobudgetFrontendStack', { 
  env: {
    region: 'us-east-1'
  }
});

console.log(backend, frontend);

