var http = require('http')
var url = require('url')
var express = require('express')
var path = require('path')

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

  webapp.use(express.static(__dirname + '/../build'));

  webapp.get('*', function(req, res, next) {
    res.sendFile(path.resolve(__dirname + '/../build/index.html'));
  })

  return webapp
}
