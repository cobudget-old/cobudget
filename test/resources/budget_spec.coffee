expect = require('../support/expect')
sinon = require('sinon')

Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/resources/budgets'

describe 'Budget Resource', ->
  before ->
    global.Budget = window.Cobudget.Resources.Budget(Restangular)

  describe 'myBudgets', ->
    it 'returns allBudgets.$object', ->
      sinon.stub(Budget, 'allBudgets').returns
        $object: 'stub-object'
      expect(Budget.myBudgets()).to.eq('stub-object')
      Budget.allBudgets.restore()

  describe 'allBudgets', ->
    it 'calls all budgets', ->
      Budget.allBudgets()
      expect(Restangular.all).to.have.been.calledWith('budgets')
