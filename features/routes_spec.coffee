expect = require('./support/expect')

describe 'basic routes are error free', ->
  it 'home page', ->
    browser.get('/')
    expect(browser.getTitle()).to.eventually.equal('Cobudget')

  it 'bucket overview', ->
    browser.get('/#/buckets/1')

  it 'bucket contributors', ->
    browser.get('/#/buckets/1/contributors')
    
