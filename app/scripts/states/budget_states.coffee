angular.module('states.budget', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('budgets',
    url: '/budgets/:id'
    views:
      'main':
        templateUrl: '/views/budgets/budget.show.html'
        controller: (['$scope', '$state', ($scope, $state)->
          console.log $state

        ]) #end controller
  ) #end state
  .state('budgets.buckets',
    url: '/buckets'
    views:
      'bucket-list':
        templateUrl: '/views/budgets/buckets.list.html'
        controller: (['$scope', '$state', "Budget", ($scope, $state, Budget)->
          Budget.query(id: $state.params.id, (response)->
            $scope.buckets = response
          )
        ]) #end controller
       'sidebar@':
         template: '<h1>sidebar</h1>'
  ) #end state
  .state('budgets.propose_bucket',
    url: '/propose-bucket'
    views:
      'bucket-create':
        template: 'create me'
        controller: (['$scope', '$state', ($scope, $state)->
          console.log "create me"
        ]) #end controller
      'sidebar@':
        template: '<h1>Instructions</h1>'
  ) #end state
]) #end config

