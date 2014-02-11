'use strict'

app = angular.module('cobudget', [
  #'ngCookies'
  'ngResource' #may not need if restangular
  'restangular'
  'ngSanitize'
  'ngAnimate'
  'config'
  'directive.g+signin'
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
  'resources.budgets'
  'resources.buckets'
  'resources.users'
  'resources.accounts'
  'resources.allocations'
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
.config(["$httpProvider", '$urlRouterProvider', '$sceDelegateProvider', 'RestangularProvider', 'ENV', ($httpProvider, $urlRouterProvider, $sceDelegateProvider, RestangularProvider, ENV)->
  $urlRouterProvider.otherwise('/')
  RestangularProvider.setBaseUrl(ENV.apiEndpoint)
  #RestangularProvider.configuration.getIdFromElem = (elem)->
    #elem[_.initial(elem.route).join('') + "_id"]
  #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded"
  #$sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:9000/**', 'http://localhost:9292/**', 'http://127.0.0.1:9292/**', 'http://cobudget.enspiral.info/**'])
])
.run(["$rootScope", "$state", "editableOptions", "User", "ENV", ($rootScope, $state, editableOptions, User, ENV) ->
  if ENV.skipSignIn
    User.getUser(1).then (success)->
      User.setCurrentUser(success)
      if User.getCurrentUser()?
        $state.go 'budgets.buckets', budget_id: User.getCurrentUser().accounts[0].budget_id
      else
        $state.go '/'
  else
    $rootScope.$on 'event:google-plus-signin-success', (event,authResult)->
      gapi.client.load 'plus','v1', ()->
        request = gapi.client.plus.people.get({'userId': 'me'})
        request.execute (resp)->
          params = {}
          emails = resp.emails.filter (v)->
            v.type == 'account'
          params.email = emails[0].value
          params.name = resp.displayName
          User.authUser(params)
            .then (success)->
              console.log success
              if success.accounts.length > 0
                User.setCurrentUser(success)
                $state.go 'budgets.buckets', budget_id: success.accounts[0].budget_id
              else
                #flash message
                console.log "No accounts"
             , (error)->
               #ERROR
      $rootScope.$on 'event:google-plus-signin-failure', (event,authResult)->
        console.log "G+ sign in error", authResult


  $rootScope.$debugMode = "on"
  $rootScope.admin = false

  editableOptions.theme = 'cobudget'

  $rootScope.pusher = new Pusher('6ea7addcc0137ddf6cf0')
  $rootScope.channel = $rootScope.pusher.subscribe('cobudget')

  $rootScope.toggleAdmin = ()->
    $rootScope.admin = !$rootScope.admin

  Pusher.log = (message)-> 
    if window.console && window.console.log
      window.console.log(message)
])
