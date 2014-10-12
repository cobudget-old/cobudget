angular
  .module('cobudget', [
    'ngRoute', 
    'restangular', 
    'ui.router',
    'budget-overview',
    'buckets-page', 
    'bucket-details', 
    'budget-contributors',
    'my-contributions',
    'budget-loader'])

  .constant('config', window.Cobudget.Config.Constants)
  .config(window.Cobudget.Config.Restangular)
  .directive('bucketList', window.Cobudget.Directives.BucketList)
  .directive('bucketSummary', window.Cobudget.Directives.BucketSummary)
  .directive('budgetBanner', window.Cobudget.Directives.BudgetBanner)
  .directive('navBar', window.Cobudget.Directives.NavBar)
  .directive('tabBar', window.Cobudget.Directives.TabBar)
  .service('Budget', window.Cobudget.Resources.Budget)
  .service('Bucket', window.Cobudget.Resources.Bucket)

  .config(
    ($stateProvider) ->
      $stateProvider.state 'budgetOverview',
        url: '/budgets/:budgetId'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'bucketsPage',
        url: '/budgets/:budgetId/buckets'
        templateUrl: '/app/buckets-page/buckets-page.html'
        controller: ''
      $stateProvider.state 'bucketsPage.bucketDetails',
        url: '/:bucketId'
        templateUrl: '/app/buckets-page/bucket-details/bucket-details.html'
        controller: 'BucketDetailsCtrl'
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
///