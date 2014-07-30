chai= require 'chai' 
chaiAsPromised = require 'chai-as-promised'
sinon_chai = require 'sinon-chai'

chai.use sinon_chai
chai.use chaiAsPromised

module.exports = chai.expect
