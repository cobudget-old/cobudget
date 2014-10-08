controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $routeParams, Budget, BudgetLoader) ->
  BudgetLoader.init($rootScope)
  
  $scope.$watch 'currentBudgetId', (id) ->
    $scope.currentBudgetId = id
    $scope.selectedTab = 'overview'




window.Cobudget.Directives.TabBar = ->
  {
    restrict: 'EA'
    templateUrl: '/app/tab-bar/tab-bar.html'
    controller: controller
  }