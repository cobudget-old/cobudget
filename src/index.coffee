if process.env.NODE_ENV != 'production'
  global.localStorage.debug = "*"

module.exports = require('app')
