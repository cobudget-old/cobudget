#TODO split relevant tests out into services/budget_loader
expect = require('../support/expect')
sinon = require('sinon')

require '../support/setup'
require '../../app/scripts/directives/nav-bar/nav-bar-directive'
require '../../app/scripts/services/budget_loader'

controller = window.Cobudget.Directives.NavBar().controller

$scope = {
  $watch: (name, callback) ->
    null
}
$rootScope = {}
Budget = {
  myBudgets: sinon.stub()
  allBudgets: ->
    then: (callback) ->
      callback(Budget.myBudgets())
}
Budget.myBudgets.returns([{id: 4}, {id: 3}])

BudgetLoader = window.Cobudget.Services.BudgetLoader()

$location =
  path: sinon.stub()

$routeParams =
  id: 1

load_controller = ->
  controller($location, $scope, $rootScope, $routeParams, Budget, BudgetLoader)

describe 'NavBar Directive Controller', ->
  beforeEach ->
    $rootScope.currentBudget = undefined
    $scope.currentBudgetId = undefined
    $scope.budgets = undefined

  describe '$scope.budgets', ->
    it 'is loaded from allBudgets callback', ->
      Budget.myBudgets.returns 'my-budgets'
      load_controller()
      expect($scope.budgets).to.eq('my-budgets')

  describe '$scope.currentBudgetId', ->
    context 'when no budget_id in route params', ->
      beforeEach ->
        $routeParams.budget_id = undefined

      it 'defaults to first budget', ->
        Budget.myBudgets.returns([{id: 4}, {id: 3}])
        load_controller()
        expect($scope.currentBudgetId).to.eq(4)
    
      it 'is set from rootScope.currentBudget', -> 
        $rootScope.currentBudget = { id: 7 }
        load_controller()
        expect($scope.currentBudgetId).to.eq(7)

  describe '$scope.watch', ->
    it 'changes the url', ->
      $scope.$watch = (string, callback) ->
        callback(1)
      load_controller()
      expect($location.path).to.have.been.calledWith('/budgets/1')
        
    
