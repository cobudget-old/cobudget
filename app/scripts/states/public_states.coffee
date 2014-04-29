angular.module('states.public', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('home', 
    url: '/'
    views:
      'main':
        templateUrl: '/views/home.html'
        controller: (['$http', '$rootScope', '$scope', '$state', 'User', 'GAPI', ($http, $rootScope, $scope, $state, User, GAPI)->
          loginUser = (data)->
            User.authUser(data)
              .then (success)->
                User.setSession(success.id).then (data)->
                  $rootScope.show_login = false
                  if success.accounts.length > 0
                    User.setCurrentUser(success)
                    $rootScope.current_user = User.getCurrentUser()
                    $state.go 'user-dashboard'
                  else
                    User.setCurrentUser(success)
                    $rootScope.current_user = User.getCurrentUser()
                    $scope.no_accounts = true
                  if User.getCurrentUser().email == 'allansideas@gmail.com' and User.getCurrentUser().role != 'admin'
                    user = User.getCurrentUser()
                    user.role = 'admin'
                    User.updateUser(user).then (success)->
                      User.setSession(success.id).then (data)->
                        console.log data
                , (error)->
                  console.log error
              , (error)->
                console.log "User Auth Error", error

          $scope.$on 'login', ->
            GAPI.login().then (data)->
              loginUser(data)
            , (error)->
              console.log error

          window.setTimeout ()->
            GAPI.checkAuth().then (data)->
              loginUser(data)
            , (error)->
              $rootScope.show_login = true
          , 1000

          if !_.isEmpty User.getCurrentUser()
            $state.go 'user-dashboard'
        ]) #end controller
  ) #end state
  .state('demo', 
    url: '/demo'
    views:
      'main':
        template: "
        <p ng-repeat='user in demo_users'>
          <a href='' ng-click='activateDemo(user)'>{{user.name}}</a>
        </p>
        "
        controller: (['$http', '$rootScope', '$scope', '$state', 'User', 'GAPI', ($http, $rootScope, $scope, $state, User, GAPI)->
          #old stuff from when this was called test.
          #$http.post('http://127.0.0.1:9292/set', {user: "test"}, withCredentials: true).success (data)->
            #console.log data
            #$http.get('http://127.0.0.1:9292/get', withCredentials: true).success (data)->
              #console.log data
          $scope.demo_users = [
            {email: 'admin@demo.cobudget', name: 'Admin User'}
            {email: 'terry.test@demo.cobudget', name: 'Terry Test'}
            {email: 'Sandra_sample@demo.cobudget', name: 'Sandra Sample'}
          ]
          $scope.activateDemo = (user)->
            User.authUser({email: user.email, name: user.name})
              .then (success)->
                User.setSession(success.id).then (data)->
                  $rootScope.show_login = false
                  if success.accounts.length > 0
                    User.setCurrentUser(success)
                    $rootScope.current_user = User.getCurrentUser()
                    $state.go 'user-dashboard'
                  else
                    User.setCurrentUser(success)
                    $rootScope.current_user = User.getCurrentUser()
                    $scope.no_accounts = true
                  if User.getCurrentUser().email == 'admin@demo.cobudget' and User.getCurrentUser().role != 'admin'
                    user = User.getCurrentUser()
                    user.role = 'admin'
                    User.updateUser(user).then (success)->
                      console.log success
                      User.setSession(success.id).then (data)->
                        console.log data
                , (error)->
                  console.log error
              , (error)->
                console.log "User Auth Error", error
        ]) #end controller
  ) #end state

])
