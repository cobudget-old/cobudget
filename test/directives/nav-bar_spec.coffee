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
BudgetLoader = window.Cobudget.Services.BudgetLoader()

describe 'NavBar Directive Controller', ->
  beforeEach ->
    $rootScope.currentBudget = undefined
    $scope.currentBudgetId = undefined
    $scope.budgets = undefined

  describe '$scope.budgets', ->
    it 'is loaded from allBudgets callback', ->
      Budget.myBudgets.returns 'my-budgets'
      controller($scope, $rootScope, Budget, BudgetLoader)
      expect($scope.budgets).to.eq('my-budgets')

  describe '$scope.currentBudgetId', ->
    it 'defaults to first budget', ->
      Budget.myBudgets.returns([{id: 4}, {id: 3}])
      controller($scope, $rootScope, Budget, BudgetLoader)
      expect($rootScope.currentBudget.id).to.eq(4)
      expect($scope.currentBudgetId).to.eq(4)
  
    it 'is set from rootScope.currentBudget', -> 
      $rootScope.currentBudget = { id: 7 }
      controller($scope, $rootScope, Budget, BudgetLoader)
      expect($scope.currentBudgetId).to.eq(7)

  describe 'setBudget', ->
    it 'sets $rootScope.currentBudget if id matches', ->
      budget = {id: 7}
      Budget.myBudgets.returns([{id: 2}, budget, {id: 1}])
      controller($scope, $rootScope, Budget, BudgetLoader)
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    it 'does nothing if scope array is empty', ->
      Budget.myBudgets.returns([])
      controller($scope, $rootScope, Budget, BudgetLoader)
      $rootScope.currentBudget = null
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)
      
    it 'does nothing if no budget with id exists', ->
      Budget.myBudgets.returns([{id: 4}, {id: 3}])
      controller($scope, $rootScope, Budget, BudgetLoader)
      $rootScope.currentBudget = null
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)

