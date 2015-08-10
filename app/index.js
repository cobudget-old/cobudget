global.jQuery = require('jquery')
global._ = require('lodash')
global.moment = require('moment')

require('angular')
require('angular-ui-router')
require('angular-sanitize/angular-sanitize')
require('angular-cookie')
require('ng-token-auth')

require('angular-aria')
require('angular-animate')
require('angular-material')
require('angular-messages')

if (process.env.NODE_ENV != 'production') {
  global.localStorage.debug = "*"
}

/* @ngInject */
global.cobudgetApp = angular.module('cobudget', [
  'ui.router',
  'ng-token-auth',
  'ngMaterial',
  'ngMessages'
])
.constant('config', require('app/configs/app'))

require('app/configs/auth.coffee')

require('app/routes.coffee')

require('app/angular-record-store.coffee')

require('app/controllers/application-controller')

require('app/records-interfaces/group-records-interface.coffee')
require('app/models/group-model.coffee')

require('app/records-interfaces/bucket-records-interface.coffee')
require('app/models/bucket-model.coffee')