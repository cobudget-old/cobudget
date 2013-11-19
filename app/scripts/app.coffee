'use strict'

app = angular.module('cobudget', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'btford.markdown'
  'ui.router'
  'controllers.buckets'
  'states.budget'
  'resources.budgets'
  'resources.buckets'
  'directives.expander'
])
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', ($httpProvider, $urlRouterProvider, $sceDelegateProvider)->
  $urlRouterProvider.otherwise('/')
  #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded"
  $sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:9000/**', 'http://localhost:9292/**', 'http://127.0.0.1:9292/**', 'http://cobudget.enspiral.info/**'])
])
.constant("API_PREFIX", "http://api.cobudget.enspiral.info/cobudget")
#.constant("API_PREFIX", "http://localhost:9292/cobudget")
.run(["$rootScope", "API_PREFIX", ($rootScope, API_PREFIX) ->
  $rootScope.$debugMode = "on"
  $rootScope.pusher = new Pusher('6ea7addcc0137ddf6cf0')
  $rootScope.channel = $rootScope.pusher.subscribe('cobudget')

  Pusher.log = (message)-> 
    if window.console && window.console.log
      window.console.log(message)
])
