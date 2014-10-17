expect = require('../support/expect')
sinon = require('sinon')

Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/resources/budgets'

describe 'Organization Resource', ->
  before ->
    global.Organization = window.Cobudget.Resources.Organization(Restangular)

  ###
  describe 'myBudgets', ->
    it 'returns allBudgets.$object', ->
      sinon.stub(Organization, 'allBudgets').returns
        $object: 'stub-object'
      expect(Organization.myBudgets()).to.eq('stub-object')
      Organization.allBudgets.restore()
  ###

  describe 'all', ->
    it 'calls all budgets', ->
      Organization.all()
      expect(Restangular.all).to.have.been.calledWith('budgets')
