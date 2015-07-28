global.jQuery = require('jquery')
require('angular')
require('bootstrap-sass/assets/javascripts/bootstrap')
require('angular-bootstrap/ui-bootstrap-tpls-0.12.0')
require('angular-route')
global.moment = require('moment')
require('angular-bootstrap-datetimepicker/src/js/datetimepicker')
require('angular-xeditable/dist/js/xeditable')
require('angular-sanitize/angular-sanitize')
require('angular-markdown-directive/markdown')
require('angular-upload')

if (process.env.NODE_ENV != 'production') {
  global.localStorage.debug = "*"
}

require('app/modules/auth')

global.cobudgetApp = angular.module('cobudget', [
  'ngRoute',
  'ui.bootstrap',
  'ui.bootstrap.datetimepicker',
  'xeditable',
  'btford.markdown',
  'lr.upload',
  'cobudget.auth'
])
.constant('config', require('app/configs/app'))
.config(require('app/configs/http'))

require('app/routes.coffee')

require('app/angular-record-store.coffee')

require('app/controllers/application-controller')
require('app/models/user-model')
require('app/modules/login')
require('app/modules/alert/model')
require('app/modules/alert/collection')