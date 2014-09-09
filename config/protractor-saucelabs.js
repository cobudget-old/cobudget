require('coffee-script');
exports.config = {
  sauceUser: process.env.SAUCE_USERNAME,
  sauceKey: process.env.SAUCE_ACCESS_KEY,

  // The address of a running selenium server.
  //seleniumAddress: 'http://localhost:4444/wd/hub',

  // Spec patterns are relative to the location of this config.
  specs: [
    '../features/*_spec.coffee'
  ],

  framework: 'mocha',

  // ----- Options to be passed to mocha -----
  //
  // See the full list at http://visionmedia.github.io/mocha/
  mochaOpts: {
    reporter: 'dot',
    enableTimeouts: false
  },

  capabilities: {
    'browserName': 'chrome',
    'tunnel-identifier': process.env.TRAVIS_JOB_NUMBER,
    'build': process.env.TRAVIS_BUILD_NUMBER,
    'name': 'ngValidation Protractor Tests'
  },

  // A base URL for your application under test. Calls to protractor.get()
  // with relative paths will be prepended with this.
  baseUrl: 'http://localhost:9001'
};
