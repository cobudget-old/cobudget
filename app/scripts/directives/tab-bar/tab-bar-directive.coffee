controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $routeParams, Budget, RoundLoader) ->
  RoundLoader.init($rootScope)
  
  $scope.$watch 'currentBudgetId', (id) ->
    $scope.currentBudgetId = id
    $scope.selectedTab = 'overview'




window.Cobudget.Directives.TabBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/tab-bar/tab-bar.html'
    controller: controller
  }