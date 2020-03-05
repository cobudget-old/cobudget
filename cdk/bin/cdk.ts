#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CobudgetBackendStack } from '../lib/backend-stack';

const app = new cdk.App();
new CobudgetBackendStack(app, 'CobudgetBackendStack');
