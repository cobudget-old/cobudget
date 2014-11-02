// Generated on 2013-11-15 using generator-angular 0.6.0-rc.1
'use strict';

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

var replace_files = [{
  expand: true,
  flatten: true,
  src: ['./config/constants.coffee'],
  dest: '<%= yeoman.app %>/app/config/'
}]


module.exports = function (grunt) {
  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  grunt.initConfig({
    yeoman: {
      // configurable paths
      app: require('./bower.json').appPath || 'src',
      dist: 'dist'
    },
    watch: {
      compass: {
        files: ['<%= yeoman.app %>/app/**/*.{scss,sass}'],
        tasks: ['compass:watch']
      },
      coffee: {
        files: ['<%= yeoman.app %>/app/**/*.coffee'],
        tasks: ['coffee:build']
      },
      coffeeTest: {
        files: ['<%= yeoman.app %>/app/**/test/*.coffee'],
        tasks: ['coffee:test']
      },
      livereload: {
        options: {
          livereload: '<%= connect.options.livereload %>'
        },
        files: [
          '<%= yeoman.app %>/**/*.html',
          '<%= yeoman.dist %>/app/**/*.css',
          '{<%= yeoman.dist %>,<%= yeoman.app %>}/app/**/*.js',
          '<%= yeoman.app %>/assets/img/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
      }
    },
    autoprefixer: {
      options: ['last 1 version'],
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>/app',
          src: '**/*.css',
          dest: '<%= yeoman.dist %>/app',
        }]
      }
    },
    connect: {
      options: {
        port: 9000,
        // Change this to '0.0.0.0' to access the server from outside.
        hostname: 'localhost',
        livereload: 35729
      },
      livereload: {
        options: {
          open: true,
          base: [
            '<%= yeoman.dist %>',
            '<%= yeoman.app %>'
          ]
        }
      },
      test: {
        options: {
          port: 9001,
          base: [
            '<%= yeoman.dist %>',
            'test',
            '<%= yeoman.app %>'
          ]
        }
      },
      dist: {
        options: {
          base: '<%= yeoman.dist %>'
        }
      }
    },
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '<%= yeoman.dist %>/*',
            '!<%= yeoman.dist %>/.git*'
          ]
        }]
      },
    },
    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: [
        'Gruntfile.js',
        '<%= yeoman.app %>/**/*.js'
      ]
    },
    compass: {
      options: {
        sassDir: '<%= yeoman.app %>/app',
        cssDir: '<%= yeoman.dist %>/app',
        generatedImagesDir: '<%= yeoman.dist %>/img/generated',
        imagesDir: '<%= yeoman.app %>/img',
        javascriptsDir: '<%= yeoman.app %>/app',
        fontsDir: '<%= yeoman.app %>/assets/fonts',
        importPath: 'bower_components',
        httpImagesPath: '/img',
        httpGeneratedImagesPath: '/img/generated',
        httpFontsPath: '/fonts',
        relativeAssets: false,
        assetCacheBuster: false
      },
      build: {

      },
      watch: {
        options: {
          debugInfo: true
        }
      }
    },
    coffee: {
      options: {
        sourceMap: true,
        sourceRoot: ''
      },
      build: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/app',
          src: '**/*.coffee',
          dest: '<%= yeoman.dist %>/app',
          extDot: 'last',
          ext: '.js'
        }]
      },
      test: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/app',
          src: '**/test/*.coffee',
          extDot: 'last',
          dest: '<%= yeoman.dist %>/test',
          ext: '.js'
        }]
      }
    },
    // not used since Uglify task does concat,
    // but still available if needed
    /*concat: {
      dist: {}
    },*/
    rev: {
      dist: {
        files: {
          src: [
            '<%= yeoman.dist %>/app/**/*.js',
            '<%= yeoman.dist %>/app/*/**/*.css',
            '<%= yeoman.dist %>/img/**/**/*.{png,jpg,jpeg,gif,webp,svg}',
            '<%= yeoman.dist %>/styles/fonts/*'
          ]
        }
      }
    },
    useminPrepare: {
      html: '<%= yeoman.app %>/index.html',
      options: {
        dest: '<%= yeoman.dist %>'
      }
    },
    usemin: {
      html: ['<%= yeoman.dist %>/**/*.html'],
      css: ['<%= yeoman.dist %>/app/**/*.css'],
      options: {
        assetsDirs: ['<%= yeoman.dist %>', '<%= yeoman.dist %>/img/css']
      }
    },
    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/assets/img',
          src: '{,*/}*.{png,jpg,jpeg}',
          dest: '<%= yeoman.dist %>/img'
        }]
      }
    },
    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/assets/img',
          src: '{,*/}*.svg',
          dest: '<%= yeoman.dist %>/img'
        }]
      }
    },
    htmlmin: {
      dist: {
        options: {
          /*removeCommentsFromCDATA: true,
          // https://github.com/yeoman/grunt-usemin/issues/44
          //collapseWhitespace: true,
          collapseBooleanAttributes: true,
          removeAttributeQuotes: true,
          removeRedundantAttributes: true,
          useShortDoctype: true,
          removeEmptyAttributes: true,
          removeOptionalTags: true*/
        },
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>',
          src: ['*.html', 'views/*.html', '<%= yeoman.app %>/**/*.html'],
          dest: '<%= yeoman.dist %>'
        }]
      }
    },
    // Put files not handled in other tasks here
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: [
            '*.{ico,png,txt}',
            '.htaccess',
            'assets/img/{,*/}*.{gif,webp}',
            'fonts/*',
            'lib/**/*',
            'static-css/**/*',
            'app/**/*.js',
            'app/**/*.html',
          ]
        }]
      },
      styles: {
        expand: true,
        cwd: '<%= yeoman.app %>/app',
        dest: '<%= yeoman.dist %>/app/',
        src: '**/*.css'
      },
      bower: {
        expand: true,
        src: 'bower_components/**/*',
        dest: '<%= yeoman.dist %>/',
      },
    },
    concurrent: {
      server: [
        'compass',
        'coffee:build',
        'copy:styles'
      ],
      test: [
        'coffee',
        'copy:styles'
      ],
      dist: [
        'compass',
        'coffee:build',
        'copy:styles',
        'imagemin',
        'svgmin',
        'htmlmin'
      ]
    },
    karma: {
      unit: {
        configFile: 'karma.conf.js',
        singleRun: true
      }
    },
    cdnify: {
      dist: {
        html: ['<%= yeoman.dist %>/*.html']
      }
    },
    ngAnnotate: {
        options: { },
        app: {
          files: [{
            expand: true,
            cwd: '<%= yeoman.dist %>/app',
            src: '**/*.js',
            dest: '<%= yeoman.dist %>/app'
          }]
        }
    },
    ngmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>/concat/app',
          src: '*.js',
          dest: '<%= yeoman.dist %>/concat/app'
        }]
      }
    },
    uglify: {
      dist: {
        files: {
          '<%= yeoman.dist %>/app/scripts.js': [
            '<%= yeoman.dist %>/app/scripts.js'
          ]
        }
      }
    },
    //TODO Get rid of the duplication with the files arrray
    replace: {
      development: {
        options: {
          patterns: [{
            json: grunt.file.readJSON('./config/environments/development.json')
          }]
        },
        files: replace_files
      },
      test: {
        options: {
          patterns: [{
            json: grunt.file.readJSON('./config/environments/test.json')
          }]
        },
        files: replace_files
      },
      travis: {
        options: {
          patterns: [{
            json: grunt.file.readJSON('./config/environments/travis.json')
          }]
        },
        files: replace_files
      },
      staging: {
        options: {
          patterns: [{
            json: grunt.file.readJSON('./config/environments/staging.json')
          }]
        },
        files: replace_files
      },
      production: {
        options: {
          patterns: [{
            json: grunt.file.readJSON('./config/environments/production.json')
          }]
        },
        files: replace_files
      }
    },
    protractor: {
      options: {
        configFile: "config/protractor.js",
        keepAlive: false, // If false, the grunt process stops when the test fails.
        noColor: false, // If true, protractor will not use colors in its output.
        args: {
          // Arguments passed to the command
        }
      },
      e2e: {
        options: {
          configFile: "./config/protractor.js",
          keepAlive: true,
          args: {}
        }
      },
      saucelabs: {
          options: {
              configFile: "./config/protractor-saucelabs.js",
              args: {
                  sauceUser: process.env.SAUCE_USERNAME,
                  sauceKey: process.env.SAUCE_ACCESS_KEY
              }
          }
      }
    },
    shell: {
      mocha: {
        command: 'mocha --compilers coffee:coffee-script/register -R min src/app/**/test/*.coffee',
        options: {
          failOnError: true
        }
      }
    },
    'gh-pages': {
      options: {
        base: '<%= yeoman.dist %>',
      },
      src: ['**'],
    },
  });

  grunt.loadNpmTasks('grunt-ng-annotate');
  grunt.loadNpmTasks('grunt-replace');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('server', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'connect:dist:keepalive']);
    }

    grunt.task.run([
      'replace:development',
      'copy:bower',
      'concurrent:server',
      'autoprefixer',
      'connect:livereload',
      'watch'
    ]);
  });

  grunt.registerTask('sauce', [
    'connect:test',
    'protractor:saucelabs',
    'shell:mocha'
  ]);

  grunt.registerTask('test', [
    'connect:test',
    'protractor:e2e',
    'shell:mocha'
  ]);

//  grunt.registerTask('test', [
//    'concurrent:test',
//    'autoprefixer',
//    'connect:test',
//    'replace:test',
//    'protractor:e2e',
//    'replace:development'
//  ]);

  grunt.registerTask('build', [
    'clean:dist',
    'useminPrepare',
    'concurrent:dist',
    'autoprefixer',
    'copy:bower',
    'copy:dist',
    'cdnify',
    'rev',
    'usemin'
  ]);

  grunt.registerTask('deploy', [
    'gh-pages',
  ]);

  grunt.registerTask('default', [
    'jshint',
    'test',
    'build',
    'deploy',
  ]);

  grunt.registerTask('staging', [
    'replace:staging',
    'build',
    'deploy',
  ]);

  grunt.registerTask('production', [
    'replace:production',
    'build',
    'deploy',
  ]);
};
