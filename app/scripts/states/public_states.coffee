angular.module('states.public', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('home', 
    url: '/'
    views:
      'main':
        templateUrl: '/views/home.html'
        controller: (['$scope', '$state', ($scope, $state)->
        ]) #end controller
  ) #end state
])
