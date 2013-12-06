'use strict'

app = angular.module('cobudget', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngAnimate',
  'flash'
  'btford.markdown'
  'ui.router'
  'filters.utils'
  'controllers.buckets'
  'states.budget'
  'states.bucket'
  'resources.budgets'
  'resources.buckets'
  'services.constrained_slider_collector'
  'directives.expander'
  'directives.slider'
  'directives.constrained_slider'
  'directives.vert_graph'
])
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', ($httpProvider, $urlRouterProvider, $sceDelegateProvider)->
  $urlRouterProvider.otherwise('/')
  #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded"
  #$sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:9000/**', 'http://localhost:9292/**', 'http://127.0.0.1:9292/**', 'http://cobudget.enspiral.info/**'])
])
#.constant("API_PREFIX", "http://api.cobudget.enspiral.info/cobudget")
.constant("API_PREFIX", "http://localhost:9292/cobudget")
.run(["$rootScope", "API_PREFIX", ($rootScope, API_PREFIX) ->
  $rootScope.$debugMode = "on"
  $rootScope.admin = false
  $rootScope.pusher = new Pusher('6ea7addcc0137ddf6cf0')
  $rootScope.channel = $rootScope.pusher.subscribe('cobudget')

  $rootScope.toggleAdmin = ()->
    if $rootScope.admin == true
      $rootScope.admin = false
    else
      $rootScope.admin = true

  Pusher.log = (message)-> 
    if window.console && window.console.log
      window.console.log(message)
])
