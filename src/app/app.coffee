angular
  .module('cobudget', [
    'ngRoute', 
    'restangular', 
    'ui.router',
    'budget-overview',
    'bucket-list', 
    'budget-contributors',
    'my-contributions',
    'budget-loader',
    ])

  .constant('config', window.Cobudget.Config.Constants)
  .config(window.Cobudget.Config.Restangular)
  .directive('budgetBanner', window.Cobudget.Directives.BudgetBanner)
  .directive('navBar', window.Cobudget.Directives.NavBar)
  .directive('tabBar', window.Cobudget.Directives.TabBar)
  .service('Budget', window.Cobudget.Resources.Budget)
  .service('Bucket', window.Cobudget.Resources.Bucket)

  .config(
    ($stateProvider, $urlRouterProvider) ->
      ///$urlRouterProvider.otherwise("/budgets/1")///

      $stateProvider.state 'budgetOverview',
        url: '/budgets/:budgetId'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'budgetCashFlow',
        url: '/budgets/:budgetId/budgetCashFlow'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'bucketList',
        url: '/budgets/:budgetId/buckets'
        templateUrl: '/app/bucket-list/bucket-list.html'
        controller: 'BucketListCtrl'
      $stateProvider.state 'bucketList.details',
        url: '/:bucketId'
        templateUrl: '/app/bucket-list/bucket-list.details.html'
        controller: ($scope, $stateParams) ->
          $scope.bucket = { id:"1", name: "fake1" }
      $stateProvider.state 'budgetContributors',
        url: '/budgets/:budgetId/contributors'
        templateUrl: '/app/budget-contributors/budget-contributors.html'
        controller: 'BudgetContributorsCtrl'
      $stateProvider.state 'myContributions',
        url: '/budgets/:budgetId/my-contributions'
        templateUrl: '/app/my-contributions/my-contributions.html'
        controller: 'MyContributionsCtrl'
  )



///
.service('BudgetLoader', window.Cobudget.Services.BudgetLoader)
.config(window.Cobudget.Config.Router)
.directive('bucketList', window.Cobudget.Directives.BucketList)
.directive('bucketSummary', window.Cobudget.Directives.BucketSummary)
///