global.jQuery = require('jquery')
require('angular')
require('bootstrap-sass/assets/javascripts/bootstrap')
require('angular-bootstrap/ui-bootstrap-tpls-0.12.0')
require('angular-ui-router')
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

angular.module('cobudget', [
  'ui.router',
  'ui.bootstrap',
  'ui.bootstrap.datetimepicker',
  'xeditable',
  'btford.markdown',
  'lr.upload',
  'cobudget.auth'
])
.constant('config', require('app/configs/app'))
.config(require('app/configs/http'))
.controller('ApplicationController', require('app/controllers/app-controller'))
.factory('UserModel', require('app/models/user-model'))
.factory('login', require('app/modules/login'))
