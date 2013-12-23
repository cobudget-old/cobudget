'use strict'

app = angular.module('cobudget', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngAnimate',
  'angular-lodash'
  'nvd3ChartDirectives'
  'flash'
  'btford.markdown'
  'ui.router'
  'filters.utils'
  'controllers.buckets'
  'controllers.budgets'
  'states.budget'
  'states.bucket'
  'resources.budgets'
  'resources.buckets'
  'services.constrained_slider_collector'
  'directives.expander'
  'directives.slider'
  'directives.constrained_slider'
  'directives.horiz_graph'
])
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', ($httpProvider, $urlRouterProvider, $sceDelegateProvider)->
  $urlRouterProvider.otherwise('/')
  #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded"
  #$sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:9000/**', 'http://localhost:9292/**', 'http://127.0.0.1:9292/**', 'http://cobudget.enspiral.info/**'])
])
.constant("API_PREFIX", "http://api.cobudget.enspiral.info/cobudget")
#.constant("API_PREFIX", "http://localhost:9292/cobudget")
.run(["$rootScope", "API_PREFIX", ($rootScope, API_PREFIX) ->
  users = [
    {id: 1, name: "Tony Soprano", allocatable: 4000}
    {id: 2, name: "Hermine Granger", allocatable: 2000}
    {id: 3, name: "Wolverine", allocatable: 1000}
    {id: 4, name: "Nomads", allocatable: 7000}
  ]
  $rootScope.$debugMode = "on"
  $rootScope.admin = false
  $rootScope.pusher = new Pusher('6ea7addcc0137ddf6cf0')
  $rootScope.channel = $rootScope.pusher.subscribe('cobudget')

  $rootScope.current_user = users[3]
  $rootScope.feignUser = (index)->
    $rootScope.current_user = users[index]
  $rootScope.toggleAdmin = ()->
    if $rootScope.admin == true
      $rootScope.admin = false
    else
      $rootScope.admin = true

  Pusher.log = (message)-> 
    if window.console && window.console.log
      window.console.log(message)
])
