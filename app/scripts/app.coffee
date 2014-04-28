'use strict'

app = angular.module('cobudget', [
  #'ngCookies'
  'ngResource' #may not need if restangular
  'restangular'
  'ngSanitize'
  'ngAnimate'
  'config'
  'angular-lodash'
  'angles'
  'flash'
  'colorpicker.module'
  'btford.markdown'
  'xeditable'
  'ui.router'
  'ui.bootstrap'
  'filters.utils'
  'controllers.buckets'
  'controllers.budgets'
  'states.public'
  'states.budget'
  'states.bucket'
  'states.admin'
  'states.user'
  'resources.budgets'
  'resources.buckets'
  'resources.users'
  'resources.accounts'
  'resources.allocations'
  'resources.comments'
  'services.constrained_slider_collector'
  'services.color_generator'
  'services.time'
  'services.gapi'
  'directives.expander'
  'directives.slider'
  'directives.constrained_slider'
  'directives.horiz_graph'
  'directives.manage_users'
  'directives.manage_allocation_rights'
  'directives.manage_budget'
  'directives.buckets_collection'
  'directives.happened_after_marker'
  'directives.comments'
  'directives.tab_switcher'
])
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', 'RestangularProvider', 'config', ($httpProvider, $urlRouterProvider, $sceDelegateProvider, RestangularProvider, config)->
  $urlRouterProvider.otherwise('/')
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
])
.run(["$rootScope", "$state", "$timeout", "editableOptions", "User", "config", ($rootScope, $state, $timeout, editableOptions, User, config) ->
  #NON DEMO
  #if _.isEmpty(User.getCurrentUser()) or !User.getCurrentUser()?
    #$state.go 'home'

  #DEMO
  if _.isEmpty(User.getCurrentUser()) or !User.getCurrentUser()?
    unless $state.is('demo')
      $state.go 'demo'

  $rootScope.$debugMode = "on"
  $rootScope.admin = false

  $rootScope.login = ->
    $rootScope.$broadcast('login')
  editableOptions.theme = 'cobudget'
  editableOptions.activate = 'select'

  $rootScope.pusher = new Pusher('6ea7addcc0137ddf6cf0')
  $rootScope.channel = $rootScope.pusher.subscribe('cobudget')

  $rootScope.toggleAdmin = ()->
    $rootScope.admin = !$rootScope.admin
    $rootScope.$broadcast('admin-mode-toggle', $rootScope.admin)

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams)->
    console.log $state.current.name
    unless $state.is('demo')
      unless toState == 'demo'
        if _.isEmpty(User.getCurrentUser()) or !User.getCurrentUser()?
          event.preventDefault()
          $timeout ()->
            event.currentScope.$apply ()->
              $state.go("home")
           , 100


  Pusher.log = (message)-> 
    if window.console && window.console.log
      window.console.log(message)
])
