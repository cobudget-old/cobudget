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
  .service('Bucket', window.Cobudget.Resources.Bucket)

  .config(
    ($stateProvider, $urlRouterProvider) ->
      ///$urlRouterProvider.otherwise("/organizations/1")///

      $stateProvider.state 'budgetOverview',
        url: '/organizations/:budgetId'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'budgetCashFlow',
        url: '/organizations/:budgetId/budgetCashFlow'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'bucketList',
        url: '/organizations/:budgetId/buckets'
        templateUrl: '/app/bucket-list/bucket-list.html'
        controller: 'BucketListCtrl'
      $stateProvider.state 'bucketList.details',
        url: '/:bucketId'
        templateUrl: '/app/bucket-list/bucket-list.details.html'
        controller: 'BucketListDetailsCtrl'
      $stateProvider.state 'budgetContributors',
        url: '/organizations/:budgetId/contributors'
        templateUrl: '/app/budget-contributors/budget-contributors.html'
        controller: 'BudgetContributorsCtrl'
      $stateProvider.state 'myContributions',
        url: '/organizations/:budgetId/my-contributions'
        templateUrl: '/app/my-contributions/my-contributions.html'
        controller: 'MyContributionsCtrl'
  )
