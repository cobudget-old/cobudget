expect = require('../support/expect')
sinon = require('sinon')

require '../support/setup'
require '../../app/scripts/services/budget_loader'

$scope = {}
$rootScope = {}

budget_loader = new window.Cobudget.Services.BudgetLoader()
budget_loader.init($scope, $rootScope)
Budget = {
  myBudgets: sinon.stub()
  allBudgets: ->
    then: (callback) ->
      callback(Budget.myBudgets())
}

describe 'BudgetLoader', ->

  describe 'loadFromRootScope', ->
  	it 'defaults $scope.currentBudgetId to ""', ->
  		budget_loader.rootScope.currentBudget = undefined
  		budget_loader.loadFromRootScope()
  		expect(budget_loader.scope.currentBudgetId).to.eq('')

  	it 'sets the scope of the currentBudgetId', ->
			budget_loader.rootScope.currentBudget = {id: 5}
			budget_loader.scope.currentBudgetId = undefined
			budget_loader.loadFromRootScope()
			expect(budget_loader.scope.currentBudgetId).to.eq(5)



