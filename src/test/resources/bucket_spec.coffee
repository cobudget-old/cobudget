expect = require('../support/expect')
sinon = require('sinon')

Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/resources/buckets'

describe 'Bucket Resource', ->
  before ->
    global.Bucket = window.Cobudget.Resources.Bucket(Restangular)

  describe 'get', ->
    it 'gets one restangular resource', ->
      Bucket.get(1)
      expect(Restangular.one).to.have.been.calledWith('buckets', 1)
