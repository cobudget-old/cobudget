'use strict'

app = angular.module('cobudget', [
  'ngCookies',
  'ngResource', #may not need if restangular
  'restangular',
  'ngSanitize',
  'ngAnimate',
  'angular-lodash'
  'angles'
  'flash'
  'colorpicker.module'
  'btford.markdown'
  'xeditable'
  'ui.router'
  'filters.utils'
  'controllers.buckets'
  'controllers.budgets'
  'states.budget'
  'states.bucket'
  'states.admin'
  'resources.budgets'
  'resources.buckets'
  'resources.users'
  'resources.accounts'
  'services.constrained_slider_collector'
  'services.color_generator'
  'directives.expander'
  'directives.slider'
  'directives.constrained_slider'
  'directives.horiz_graph'
  'directives.manage_users'
  'directives.manage_allocation_rights'
  'directives.manage_budget'
])
#.constant("API_PREFIX", "http://api.cobudget.enspiral.info/cobudget")
#:9393 = shotgun, :9292 = rackup
.constant("API_PREFIX", "http://localhost:9292/cobudget")
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', 'RestangularProvider', 'API_PREFIX', ($httpProvider, $urlRouterProvider, $sceDelegateProvider, RestangularProvider, API_PREFIX)->
  $urlRouterProvider.otherwise('/')
  RestangularProvider.setBaseUrl(API_PREFIX)
  #RestangularProvider.configuration.getIdFromElem = (elem)->
    #elem[_.initial(elem.route).join('') + "_id"]
  #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded"
  #$sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:9000/**', 'http://localhost:9292/**', 'http://127.0.0.1:9292/**', 'http://cobudget.enspiral.info/**'])
])
.run(["$rootScope", "API_PREFIX", "editableOptions", ($rootScope, API_PREFIX, editableOptions) ->
  users = [
    {id: 1, name: "Tony Soprano", allocatable: 4000}
    {id: 2, name: "Hermine Granger", allocatable: 2000}
    {id: 3, name: "Wolverine", allocatable: 1000}
    {id: 4, name: "Nomads", allocatable: 7000}
  ]
  $rootScope.$debugMode = "on"
  $rootScope.admin = false
  editableOptions.theme = 'cobudget'
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
