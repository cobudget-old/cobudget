expect = require('../support/expect')

describe 'Namespace', ->
  before ->
    global.window = {}
    expect(window.Cobudget).to.eq(undefined)
    require '../../app/scripts/config/namespace'

  it 'creates a cobudget namespace', ->
    expect(window.Cobudget).to.be.an('object')

  it 'creates a config namespace', ->
    expect(window.Cobudget.Config).to.be.an('object')

  it 'creates a controllers namespace', ->
    expect(window.Cobudget.Controllers).to.be.an('object')

  it 'creates a directives namespace', ->
    expect(window.Cobudget.Directives).to.be.an('object')

  it 'creates a resources namespace', ->
    expect(window.Cobudget.Resources).to.be.an('object')
