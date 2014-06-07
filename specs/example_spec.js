describe('home', function() {
  it('works', function() {
    // Load the AngularJS homepage.
    browser.get('/')
    greeting = element(by.model('greeting'));
    expect(greeting.getText()).toEqual('Hello');
  });
});
