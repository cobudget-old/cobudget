sinon = require('sinon')

Restangular = sinon.stub(
  all: sinon.stub
  one: sinon.stub
)

Restangular.all.returns
  getList: ->

Restangular.one.returns
  get: ->

module.exports = Restangular
