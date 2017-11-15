global.jQuery = require('jquery')
global._ = require('lodash')
global.moment = require('moment')
global.camelize = require('camelize')
global.morph = require('morph')
global.listify = require('listify')
global.isEmptyObject = require('is-empty-object')
global.browser = require('bowser')
global.Highcharts = require('highcharts')

require('angular')
require('angular-ui-router')
require('angular-sanitize/angular-sanitize')
require('angular-cookie')
require('ng-token-auth')
require('angular-aria')
require('angular-animate')
require('angular-material')
require('angular-messages')
require('ng-focus-if')
require('angular-upload')
require('angular-material-icons')
require('ng-sanitize')
require('angular-truncate-2')
require('angular-marked')
require('ng-q-all-settled')
require('ng-csv')
require('angular-chart.js')
require('angular-autodisable/angular-autodisable')
require('highcharts-ng')
require('angular-material-data-table')
require('ment.io')

if (process.env.NODE_ENV != 'production') {
  global.localStorage.debug = "*"
}

/* @ngInject */
global.cobudgetApp = angular.module('cobudget', [
  'ui.router',
  'ng-token-auth',
  'ngMaterial',
  'ngMessages',
  'ipCookie',
  'focus-if',
  'lr.upload',
  'ngMdIcons',
  'ngSanitize',
  'truncate',
  'hc.marked',
  'qAllSettled',
  'ngCsv',
  'chart.js',
  'ngAutodisable',
  'highcharts-ng',
  'md.data.table',
  'mentio'
])
.constant('config', require('app/configs/app'))

require('app/configs/auth.coffee')
require('app/configs/chart-js.coffee')
require('app/configs/marked.coffee')

require('app/routes.coffee')
require('app/angular-record-store.coffee')

var concatenify = require('concatenify')
concatenify('./controllers/*.{js,coffee}')
concatenify('./records-interfaces/*.{js,coffee}')
concatenify('./models/*.{js,coffee}')
concatenify('./filters/*.{js,coffee}')
concatenify('./services/*.{js,coffee}')
concatenify('./directives/**/*.{js,coffee}')

require('app/boot.coffee')
