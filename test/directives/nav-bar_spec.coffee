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

load_controller = ->
  controller($location, $scope, $rootScope, Budget, BudgetLoader)

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
    it 'defaults to first budget', ->
      Budget.myBudgets.returns([{id: 4}, {id: 3}])
      load_controller()
      expect($rootScope.currentBudget.id).to.eq(4)
      expect($scope.currentBudgetId).to.eq(4)
  
    it 'is set from rootScope.currentBudget', -> 
      $rootScope.currentBudget = { id: 7 }
      load_controller()
      expect($scope.currentBudgetId).to.eq(7)

  describe 'setBudget', ->
    it 'sets $rootScope.currentBudget if id matches', ->
      budget = {id: 7}
      Budget.myBudgets.returns([{id: 2}, budget, {id: 1}])
      load_controller()
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    it 'does nothing if scope array is empty', ->
      Budget.myBudgets.returns([])
      load_controller()
      $rootScope.currentBudget = null
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)
      
    it 'does nothing if no budget with id exists', ->
      Budget.myBudgets.returns([{id: 4}, {id: 3}])
      load_controller()
      $rootScope.currentBudget = null
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)

  describe '$scope.watch', ->
    it 'changes the url', ->
      $scope.$watch = (string, callback) ->
        callback(1)
      load_controller()
      expect($location.path).to.have.been.calledWith('/budgets/1')
        
    
