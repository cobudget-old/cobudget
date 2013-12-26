angular.module('states.admin', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('admin', 
    url: '/admin'
    abstract: true
    views:
      'main':
        templateUrl: '/views/admin/admin.base.html'
        controller: (['$scope', '$state', ($scope, $state)->
        ]) #end controller
  ) #end state
  .state('admin.dashboard',
    url: '/dashboard'
    views:
      'header-full':
        template: "Header"
      'page-full':
        templateUrl: '/views/admin/dashboard.html'
        controller: (['$scope', '$state', 'User', ($scope, $state, User)->
          $scope.mode = ""
          $scope.search = ""
          $scope.users = {}
          $scope._user = {}

          $scope.createUser = ()->
            User.createUser($scope._user).then((success)->
              $scope.users.unshift(success)
              $scope._user = {}
              $scope.mode =""
            , (error)->
              console.log error
            )

          $scope.toggle = (mode)->
            if $scope.mode == mode
              $scope.mode = ""
            else $scope.mode = mode

          User.allUsers().then((success)->
            $scope.users = success
          , (error)->
            console.log error
          )
        ]) #end controller'
  )
  .state('admin.allocation_rights',
    url: '/allocation-rights'
    views:
      'header':
        template: "Header"
      'page':
        templateUrl: '/views/admin/allocations.grant.html'
        controller: 'BucketController'
      'sidebar':
         template: '<h1>sidebar</h1>'
  ) #end state
]) #end config

