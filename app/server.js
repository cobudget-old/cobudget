var http = require('http')
var url = require('url')
var express = require('express')

var env = process.env
var nodeEnv = env.NODE_ENV || 'development'

if (env.NODE_ENV !== 'production') {
  require('debug').enable("*")
}

module.exports = function (options) {
  options = options || {}

  var webapp = express()

  // add livereload middleware if dev
  if (nodeEnv == 'development') {
    webapp.use(require('connect-livereload')({
      port: env.LIVERELOAD_PORT || 35729
    }))
  }

  webapp.use(require('ecstatic')({
    root: options.root || __dirname + '/../build',
    cache: options.cache ||
      env.NODE_ENV == 'production' ? 3600 : 0
    ,
    showDir: false,
    autoIndex: true
  }))

  return webapp
}
