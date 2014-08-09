expect = require('../support/expect')
sinon = require('sinon')

require '../support/setup'
require '../../app/scripts/directives/nav-bar/nav-bar-directive'

controller = window.Cobudget.Directives.NavBar().controller

$scope = {
  $watch: (name, callback) ->
    null
}
$rootScope = {}
Budget = {
  myBudgets: sinon.stub()
}

describe 'NavBar Directive Controller', ->
  describe '$scope.budgets', ->
    it 'is loaded from Budget.myBudgets()', ->
      Budget.myBudgets.returns 'my-budgets'
      controller($scope, $rootScope, Budget)
      expect($scope.budgets).to.eq('my-budgets')

  describe '$scope.currentBudgetId', ->
    it 'defaults to empty string', ->
      controller($scope, $rootScope, Budget)
      expect($scope.currentBudgetId).to.eq('')
  
    it 'is set from rootScope.currentBudget', -> 
      $rootScope.currentBudget = { id: 7 }
      controller($scope, $rootScope, Budget)
      expect($scope.currentBudgetId).to.eq(7)

  describe 'setBudget', ->
    beforeEach ->
      $rootScope.currentBudget = null

    it 'sets $rootScope.currentBudget if id matches', ->
      budget = {id: 7}
      Budget.myBudgets.returns([{id: 2}, budget, {id: 1}])
      controller($scope, $rootScope, Budget)
      $scope.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    it 'does nothing if scope array is empty', ->
      Budget.myBudgets.returns([])
      controller($scope, $rootScope, Budget)
      $scope.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)
      
    it 'does nothing if no budget with id exists', ->
      Budget.myBudgets.returns([{id: 4}, {id: 3}])
      controller($scope, $rootScope, Budget)
      $scope.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)

