'use strict'

app = angular.module('cobudget', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router'
  'states.budget'
  'resources.budgets'
])
.config(["$httpProvider", '$urlRouterProvider', ($httpProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise('/')
  $httpProvider.defaults.useXDomain = true
])
#.constant("API_PREFIX", "http://api.cobudget.enspiral.info/cobudget")
.constant("API_PREFIX", "http://localhost:9292/cobudget")
.run(["$rootScope", "API_PREFIX", ($rootScope, API_PREFIX) ->
  $rootScope.$debugMode = "on"
])
