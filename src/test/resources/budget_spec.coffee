expect = require('../support/expect')
sinon = require('sinon')

Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/resources/budgets'

describe 'Group Resource', ->
  before ->
    global.Group = window.Cobudget.Resources.Group(Restangular)

  ###
  describe 'myBudgets', ->
    it 'returns allBudgets.$object', ->
      sinon.stub(Group, 'allBudgets').returns
        $object: 'stub-object'
      expect(Group.myBudgets()).to.eq('stub-object')
      Group.allBudgets.restore()
  ###

  describe 'all', ->
    it 'calls all budgets', ->
      Group.all()
      expect(Restangular.all).to.have.been.calledWith('budgets')
