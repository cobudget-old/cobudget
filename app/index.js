global.jQuery = require('jquery')
global._ = require('lodash')
global.moment = require('moment')

require('angular')
require('angular-ui-router')
require('angular-sanitize/angular-sanitize')
require('angular-cookie')
require('ng-token-auth')

if (process.env.NODE_ENV != 'production') {
  global.localStorage.debug = "*"
}

/* @ngInject */
global.cobudgetApp = angular.module('cobudget', [
  'ui.router',
  'ng-token-auth'
])
.constant('config', require('app/configs/app'))

require('app/configs/auth.coffee')

require('app/routes.coffee')

require('app/angular-record-store.coffee')

require('app/controllers/application-controller')

require('app/records-interfaces/group-records-interface.coffee')
require('app/models/group-model.coffee')