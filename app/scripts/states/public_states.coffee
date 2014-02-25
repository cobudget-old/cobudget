angular.module('states.public', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('home', 
    url: '/'
    views:
      'main':
        templateUrl: '/views/home.html'
        controller: (['$http', '$rootScope', '$scope', '$state', 'User', 'GAPI', ($http, $rootScope, $scope, $state, User, GAPI)->
          loginUser = (data)->
            console.log data
            User.authUser(data)
              .then (success)->
                User.setSession(success.id).then (data)->
                  if success.accounts.length > 0
                    User.setCurrentUser(success)
                    $rootScope.current_user = User.getCurrentUser()
                    $state.go 'user-dashboard'
                  else
                    User.setCurrentUser(success)
                    $rootScope.current_user = User.getCurrentUser()
                    $scope.no_accounts = true
                , (error)->
                  console.log error
              , (error)->
                console.log "User Auth Error", error

          $scope.login = ->
            console.log "login click"
            GAPI.login().then (data)->
              loginUser(data)
            , (error)->
              console.log error

          window.setTimeout ()->
            GAPI.checkAuth().then (data)->
              loginUser(data)
              $scope.show_login = false
            , (error)->
              $scope.show_login = true
          , 1000

          if !_.isEmpty User.getCurrentUser()
            $state.go 'user-dashboard'
        ]) #end controller
  ) #end state
  .state('test', 
    url: '/test'
    views:
      'main':
        templateUrl: '/views/home.html'
        controller: (['$http', '$rootScope', '$scope', '$state', 'User', 'GAPI', ($http, $rootScope, $scope, $state, User, GAPI)->
          $http.post('http://127.0.0.1:9292/set', {user: "test"}, withCredentials: true).success (data)->
            console.log data
            $http.get('http://127.0.0.1:9292/get', withCredentials: true).success (data)->
              console.log data

        ]) #end controller
  ) #end state

])
