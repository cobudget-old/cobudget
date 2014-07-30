expect = require('./support/expect')

describe 'home title', ->
  it 'says cobudget', ->
    browser.get('/')
    expect(browser.getTitle()).to.eventually.equal('Cobudget')
