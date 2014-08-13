expect = require('../support/expect')
sinon = require('sinon')

require '../support/setup'
require '../../app/scripts/services/budget_loader'

$scope = {}
$rootScope = {}

budget_loader = new window.Cobudget.Services.BudgetLoader()
budget_loader.init($scope, $rootScope)

describe 'BudgetLoader', ->
  beforeEach ->
    $rootScope.currentBudget = undefined
    $scope.currentBudgetId = undefined
    $scope.budgets = undefined

  describe 'loadFromRootScope', ->
  	it 'defaults $scope.currentBudgetId to ""', ->
  		budget_loader.loadFromRootScope()
  		expect($scope.currentBudgetId).to.eq('')

  	it 'sets the scope of the currentBudgetId', ->
			$rootScope.currentBudget = {id: 5}
			budget_loader.loadFromRootScope()
			expect($scope.currentBudgetId).to.eq(5)

  describe 'defaultToFirstBudget', ->
    beforeEach ->
      $scope.budgets = [{id: 1},{id:7}, {id:3}]

    it 'does nothing if scope.budgets empty', ->
      $scope.budgets = []
      budget_loader.defaultToFirstBudget()
      expect($rootScope.currentBudget).to.eq(undefined)

    describe 'when scope.currentBudgetId is unset', ->
      beforeEach ->
        $scope.currentBudgetId = ''
        budget_loader.defaultToFirstBudget()

      it 'sets rootScope.currentBudget to the first budget', ->
        expect($rootScope.currentBudget).to.eq($scope.budgets[0])

      it 'sets scope.currentBudgetId to the budget id', ->
        expect($scope.currentBudgetId).to.eq(1)

    describe 'when scope.currentBudgetId is set', ->
      beforeEach ->
        $scope.currentBudgetId = 7
        budget_loader.defaultToFirstBudget()

      it 'does not change the current budgetId', ->
        expect($scope.currentBudgetId).to.eq(7)

  describe 'setBudget', ->
    it 'sets rootScope.currentBudget to the first budget with matching id'



