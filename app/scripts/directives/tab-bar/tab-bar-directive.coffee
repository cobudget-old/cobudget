controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $routeParams, Budget, BudgetLoader) ->
  BudgetLoader.init($rootScope)

  $scope.$watch 'currentBudgetId', (id) ->
    $scope.currentBudgetId = id



window.Cobudget.Directives.TabBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/tab-bar/tab-bar.html'
    controller: controller
  }