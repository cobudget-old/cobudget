gulp = require('gulp')
watch = require('gulp-watch')
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
util = require('gulp-util')
plumber = require('gulp-plumber')
sourcemaps = require('gulp-sourcemaps')
extend = require('xtend')
_ = require('lodash')

refresh = require('gulp-livereload')
lrServer = require('tiny-lr')()

# default environment to development
process.env.NODE_ENV or= 'development'

env = process.env
nodeEnv = env.NODE_ENV

isDeploy = (env) ->
  env == "production" or env == "staging"

lr = undefined
errorHandler = (err) ->
  util.beep()
  util.log(util.colors.red(err))

#
# styles
#
sass = require('gulp-sass')
autoprefix = require('gulp-autoprefixer')
rename = require('gulp-rename')
filter = require('gulp-filter')

sassPaths =  [
  "node_modules/bootstrap-sass/assets/stylesheets/"
  "node_modules/font-awesome/scss/"
  "node_modules/angular-xeditable/dist/css"
  "node_modules/angular-bootstrap-datetimepicker/src/css"
]

styles = ->

  entryFilter = filter (file) ->
    /src\/[^\/]+\.(sass|scss)$/.test(file.path)

  srcPaths = ['src/**/']
    .concat(sassPaths)
    .map (path) -> path + "*.{sass,scss}"

  gulp.src(srcPaths)
    .pipe(plumber(
      errorHandler: (err) ->
        errorHandler(err)
        # https://github.com/floatdrop/gulp-plumber/issues/8
        this.emit('end')
    ))
    .pipe(sourcemaps.init())
    .pipe(entryFilter)
    .pipe(sass(
      includePaths: sassPaths
    ))
    .pipe(sourcemaps.write(includeContent: false))
    .pipe(sourcemaps.init(loadMaps: true))
    .pipe(autoprefix(
      browsers: ['> 1%', 'last 2 versions']
    ))
    .pipe(sourcemaps.write('../maps', sourceRoot: '../styles/'))
    .pipe(gulp.dest('build/styles'))
    .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

gulp.task 'styles-build', styles
gulp.task 'styles-watch', ['styles-build'], ->
  gulp.watch('src/**/*.sass', ['styles-build'])

#
# scripts
#
browserify = require('browserify')
mold = require('mold-source-map')

scripts = (isWatch) ->
  ->
    plugin = (bundler) ->
      bundler
        .plugin(require('bundle-collapser/plugin'))

    bundle = (bundler) ->
      bundler.bundle()
        .on('error', util.log.bind(util, "browserify error"))
        .pipe(plumber({ errorHandler }))
        .pipe(mold.transformSourcesRelativeTo('./src'))
        .pipe(source('index.js'))
        .pipe(buffer())
        .pipe(sourcemaps.init(loadMaps: true))
        .pipe(if isDeploy(nodeEnv) then require('gulp-uglify')() else util.noop())
        .pipe(sourcemaps.write('../maps'))
        .pipe(gulp.dest('build/scripts'))
        .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

    args = {
      entries: ['.']
      debug: true
    }

    if (isWatch)
      watchify = require('watchify')
      bundler = watchify(browserify(extend(args, watchify.args)))
      rebundle = -> bundle(bundler)
      bundler.on('update', rebundle)
      bundler.on('log', console.log.bind(console))
      rebundle()
    else
      bundle(plugin(browserify(args)))

gulp.task 'scripts-build', scripts(false)
gulp.task 'scripts-watch', scripts(true)

#
# assets
#
html = (isWatch) ->
  glob = 'src/index.html'
  ->
    gulp.src(glob)
      .pipe(if isWatch then watch(glob) else util.noop())
      .pipe(gulp.dest('build'))
      .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

gulp.task 'html-build', html(false)
gulp.task 'html-watch', html(true)

assetPaths = {
  "src/assets/**/*": "build"
  "node_modules/es5-shim/es5-shim*": "build/lib/es5-shim"
  "node_modules/json3/lib/json3*": "build/lib/json3"
  "node_modules/font-awesome/fonts/*": "build/fonts/font-awesome"
  "node_modules/bootstrap-sass/assets/fonts/bootstrap/*": "build/fonts/bootstrap"
  "node_modules/angular-bootstrap-datetimepicker/src/css/datetimepicker.css": "build/styles"
  "node_modules/angular-xeditable/dist/css/xeditable.css": "build/styles"
}

assets = (isWatch) ->
  ->
    _.each assetPaths, (to, from) ->
      gulp.src(from, dot: true)
        .pipe(if isWatch then watch(from) else util.noop())
        .pipe(gulp.dest(to))
        .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

gulp.task 'assets-build', assets(false)
gulp.task 'assets-watch', assets(true)


#
# server
#
nodemon = require('gulp-nodemon')

server = (cb) ->
  nodemon(
    script: "server.js"
    ext: "js json coffee html"
    ignore: [".git", "node_modules", "build"]
    env: env
  )

gulp.task('server', server)

#
# livereload
#

livereload = (cb) ->
  lr = require('tiny-lr')()
  lr.listen(env.LIVERELOAD_PORT or 35729, cb)

gulp.task('livereload', livereload)

#
# gh-pages
#
gulp.task 'branch', ['build'], ->
  branch = require('gulp-build-branch')
  branch(
    folder: 'build'
  )

# prod tasks
gulp.task('build', ['scripts-build', 'styles-build', 'html-build', 'assets-build'])
gulp.task('default', ['server'])
gulp.task('start', ['build', 'server'])

# dev tasks
gulp.task('watch', ['scripts-watch', 'styles-watch', 'html-watch', 'assets-watch'])
gulp.task('develop', ['livereload', 'watch', 'server'])

