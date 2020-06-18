import { _ } from "lodash";
import { moment } from "moment";
import { camelize } from "camelize";
import { morph } from "morph";
import { Highcharts } from "highcharts";

require("angular");
require("angular-ui-router");
require("angular-sanitize/angular-sanitize");
require("ng-token-auth");
require("angular-aria");
require("angular-animate");
require("angular-material");
require("angular-messages");
require("ng-focus-if");
require("angular-upload");
require("angular-material-icons");
require("ng-sanitize");
require("angular-truncate-2");
require("angular-marked");
require("ng-q-all-settled");
require("ng-csv");
require("angular-chart.js");
require("angular-autodisable/angular-autodisable");
require("highcharts-ng");
require("angular-material-data-table");
require("ment.io");

import * as Sentry from "@sentry/node";
import { Angular as AngularIntegration } from "@sentry/integrations";

Sentry.init({
  dsn:
    "https://c87f3b754cba4467ba54eb82cea06e83@o365863.ingest.sentry.io/5253228",
  release: "COBUDGET_RELEASE_VERSION",
  environment: "SENTRY_ENVIRONMENT",
  integrations: [new AngularIntegration()],
});

if (process.env.NODE_ENV != "production") {
  localStorage.debug = "*";
}

/* @ngInject */
cobudgetApp = angular
  .module("cobudget", [
    "ui.router",
    "ng-token-auth",
    "ngMaterial",
    "ngMessages",
    "focus-if",
    "lr.upload",
    "ngMdIcons",
    "ngSanitize",
    "truncate",
    "hc.marked",
    "qAllSettled",
    "ngCsv",
    "chart.js",
    "ngAutodisable",
    "highcharts-ng",
    "md.data.table",
    "mentio",
    "ngSentry",
  ])
  .constant("config", require("app/configs/app"));

require("app/configs/auth.ts");
require("app/configs/chart-js.ts");
require("app/configs/marked.ts");

require("app/routes.ts");
require("app/angular-record-store.ts");

require("app/boot.ts");
