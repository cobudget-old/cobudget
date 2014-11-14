gulp = require('gulp')
watch = require('gulp-watch')
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
util = require('gulp-util')
plumber = require('gulp-plumber')
sourcemaps = require('gulp-sourcemaps')
extend = require('xtend')

refresh = require('gulp-livereload')
lrServer = require('tiny-lr')()

# default environment to development
process.env.NODE_ENV or= 'development'

env = process.env
nodeEnv = env.NODE_ENV

lr = undefined

#
# styles
#
sass = require('gulp-sass')
autoprefix = require('gulp-autoprefixer')
rename = require('gulp-rename')

sassPaths =  [
  __dirname + "/node_modules/bootstrap-sass/assets/stylesheets/"
  __dirname + "/node_modules/font-awesome/scss/"
]

styles = (isWatch) ->

  srcPath = "src/*.sass"
  watchPath = "src/**/*.sass"

  ->
    gulp.src(srcPath)
      .pipe(if isWatch then watch(watchPath) else util.noop())
      .pipe(plumber())
      .pipe(sourcemaps.init())
      .pipe(sass(
        includePaths: sassPaths
      ))
      .pipe(rename(extname: ".sass"))
      .pipe(autoprefix(
        browsers: ['> 1%', 'last 2 versions']
      ))
      .pipe(rename(extname: ".css"))
      .pipe(sourcemaps.write('../maps'))
      .pipe(gulp.dest('build/styles'))
      .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

gulp.task 'styles-build', styles(false)
gulp.task 'styles-watch', styles(true)

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
        .pipe(plumber())
        .pipe(mold.transformSourcesRelativeTo('./src'))
        .pipe(source('index.js'))
        .pipe(buffer())
        .pipe(sourcemaps.init(loadMaps: true))
        .pipe(if nodeEnv == 'production' then require('gulp-uglify')() else util.noop())
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

assets = (isWatch) ->
  glob = ['src/assets/**/*', 'node_modules/es5-shim', 'node_modules/json3']
  ->
    gulp.src(glob)
      .pipe(if isWatch then require('gulp-watch')(glob) else util.noop())
      .pipe(gulp.dest('build'))
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

# prod tasks
gulp.task('build', ['scripts-build', 'styles-build', 'html-build', 'assets-build'])

# dev tasks
gulp.task('watch', ['scripts-watch', 'styles-watch', 'html-watch', 'assets-watch'])
gulp.task('develop', ['livereload', 'watch', 'server'])

gulp.task('default', ['server'])
