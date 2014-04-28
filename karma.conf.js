// Karma configuration
// http://karma-runner.github.io/0.10/config/configuration-file.html

module.exports = function(config) {
  config.set({
    preprocessors: {
      '**/*.coffee': ['coffee']
    },

    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
        bare: true,
        sourceMap: false
      },
      // transforming the filenames
      transformPath: function(path) {
        return path.replace(/\.coffee$/, '.js');
      }
    },
    // base path, that will be used to resolve files and exclude
    basePath: '',

    // testing framework to use (jasmine/mocha/qunit/...)
    frameworks: ['jasmine'],

    // list of files / patterns to load in the browser
    files: [

      //need to be above angular-mocks
      'app/bower_components/moment/moment.js',
      'app/bower_components/moment-timezone/moment-timezone.js',
      'app/modded_components/moment-timezone-data.js',

      'app/bower_components/jquery/dist/jquery.js',
      'app/bower_components/nouislider/jquery.nouislider.js',

      'app/bower_components/lodash/dist/lodash.js',
      'app/bower_components/angular/angular.js',
      'app/bower_components/angular-mocks/angular-mocks.js',
      'app/bower_components/angular-resource/angular-resource.js',
      'app/bower_components/angular-cookies/angular-cookies.js',
      'app/bower_components/angular-sanitize/angular-sanitize.js',
      'app/bower_components/angular-route/angular-route.js',
      'app/bower_components/angular-lodash/angular-lodash.js',
      'app/bower_components/angular-animate/angular-animate.js',
      'app/bower_components/angular-ui-router/release/angular-ui-router.js',
      'app/modded_components/angular-flash-messages/angular-flash.js',
      'app/modded_components/angular-markdown-directive/markdown.js',
      'app/bower_components/restangular/dist/restangular.js',
      'app/bower_components/Chart.js/Chart.js',
      'app/bower_components/angles/angles.js',
      'app/modded_components/angular-xeditable/dist/js/xeditable.js',
      'app/modded_components/ui-bootstrap-typeahead/ui-bootstrap-custom-0.9.0.js',
      'app/modded_components/ui-bootstrap-typeahead/ui-bootstrap-custom-tpls-0.9.0.js',
      'app/bower_components/showdown/compressed/showdown.js',
      'app/bower_components/angular-bootstrap-colorpicker/js/bootstrap-colorpicker-module.js',

      'app/modded_components/temporal.js',

      'test/mocks/pusher/pusher.coffee',
      'app/scripts/*.coffee',
      'app/scripts/**/*.coffee',
      'test/mocks/**/*.coffee',
      'test/spec/**/*.coffee'
    ],

    // list of files / patterns to exclude
    exclude: [],

    // web server port
    port: 8080,

    // level of logging
    // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: false,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['Chrome'],


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false
  });
};
