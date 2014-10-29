angular
  .module('cobudget', [
    'ngRoute',
    'restangular',
    'ui.router',
    'ui.bootstrap',
    'auth',
    'nav-bar',
    'budget-tab-bar',
    'budget-overview',
    'bucket-list',
    'budget-contributors',
    'my-contributions',
    ])

  .constant('config', window.Cobudget.Config.Constants)
  .directive('budgetBanner', window.Cobudget.Directives.BudgetBanner)

  .config(
    ($stateProvider, $urlRouterProvider) ->
      $urlRouterProvider.otherwise("/")
      $stateProvider.state 'nav',
        url: ''
        templateUrl: '/app/nav-bar/nav-bar.html'
        controller: 'NavBarCtrl'
        resolve:
          groups: (GroupService) ->
            GroupService.all()
      $stateProvider.state 'nav.budget',
        url: '/groups/:groupId'
        templateUrl: '/app/tab-bar/tab-bar.html'
        controller: 'BudgetTabBarCtrl'
      $stateProvider.state 'nav.budget.overview',
        url: '/overview'
        templateUrl: '/app/budget-overview/budget-overview.html'
        controller: 'BudgetOverviewCtrl'
      $stateProvider.state 'nav.budget.buckets',
        url: '/buckets'
        templateUrl: '/app/bucket-list/bucket-list.html'
        controller: 'BucketListCtrl'
        resolve:
          latestRound: (RoundService, $stateParams) ->
            RoundService.getLatestRound($stateParams.groupId)
      $stateProvider.state 'nav.budget.buckets.details',
        url: '/:bucketId'
        templateUrl: '/app/bucket-list/bucket-list.details.html'
        controller: 'BucketListDetailsCtrl'
      $stateProvider.state 'nav.budget.contributors',
        url: '/contributors'
        templateUrl: '/app/budget-contributors/budget-contributors.html'
        controller: 'BudgetContributorsCtrl'
        resolve:
          latestRound: (RoundService, $stateParams) ->
            RoundService.getLatestRound($stateParams.groupId)
      $stateProvider.state 'nav.budget.myContributions',
        url: '/my-contributions'
        templateUrl: '/app/my-contributions/my-contributions.html'
        controller: 'MyContributionsCtrl'
  )
