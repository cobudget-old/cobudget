chai= require('chai')
chaiAsPromised=require('chai-as-promised')
chai.use(chaiAsPromised)
expect=chai.expect

describe('home', function() {
  it('works', function() {
    // Load the homepage
    browser.get('/')
    expect(browser.getTitle()).to.eventually.equal('Cobudget');
  });
});
