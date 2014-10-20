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
    'round-loader',
    'bucket-loader'
    ])

  .constant('config', window.Cobudget.Config.Constants)
  .directive('budgetBanner', window.Cobudget.Directives.BudgetBanner)
  .directive('navBar', window.Cobudget.Directives.NavBar)
  .directive('tabBar', window.Cobudget.Directives.TabBar)

  .config(
    ($stateProvider, $urlRouterProvider) ->
      ///$urlRouterProvider.otherwise("/groups/1")///

      $stateProvider.state 'budgetOverview',
        url: '/groups/:budgetId'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'budgetCashFlow',
        url: '/groups/:budgetId/budgetCashFlow'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'bucketList',
        url: '/groups/:budgetId/buckets'
        templateUrl: '/app/bucket-list/bucket-list.html'
        controller: 'BucketListCtrl'
      $stateProvider.state 'bucketList.details',
        url: '/:bucketId'
        templateUrl: '/app/bucket-list/bucket-list.details.html'
        controller: 'BucketListDetailsCtrl'
      $stateProvider.state 'budgetContributors',
        url: '/groups/:budgetId/contributors'
        templateUrl: '/app/budget-contributors/budget-contributors.html'
        controller: 'BudgetContributorsCtrl'
      $stateProvider.state 'myContributions',
        url: '/groups/:budgetId/my-contributions'
        templateUrl: '/app/my-contributions/my-contributions.html'
        controller: 'MyContributionsCtrl'
  )
