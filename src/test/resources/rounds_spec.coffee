expect = require('../support/expect')
sinon = require('sinon')

Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/resources/rounds'

describe 'Round Resource', ->
  before ->
    global.Round = window.Cobudget.Resources.Round(Restangular)

  describe 'get', ->
    it 'calls one rounds with id', ->
      Round.get(1)
      expect(Restangular.one).to.have.been.calledWith('rounds', 1)