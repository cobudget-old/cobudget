angular.module('states.budget', ['controllers.buckets'])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('budgets',
    url: '/budgets/:budget_id'
    views:
      'main':
        templateUrl: '/views/budgets/budget.show.html'
        controller: 'BudgetController'
  ) #end state
  .state('budgets.buckets',
    url: '/buckets'
    views:
      'bucket-list':
        templateUrl: '/views/buckets/buckets.list.html'
      'sidebar':
        template: '
          <h1>sidebar</h1>
          <p ng-repeat="b in buckets">{{b.allocations}}</p>
          '
  ) #end state
  .state('budgets.propose_bucket',
    url: '/propose-bucket'
    views:
      'bucket-create':
        templateUrl: '/views/buckets/buckets.create.html'
        controller: 'BucketController'
      'sidebar':
        template: '<h1>Instructions</h1>'
  ) #end state
]) #end config

