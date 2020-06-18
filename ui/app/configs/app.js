import assign from 'lodash/assign'

const defaults = require('../../config/defaults')
const config = require('../../config/' + (process.env.APP_ENV || process.env.NODE_ENV || 'development'))

module.exports = assign({}, defaults, config, {
  env: process.env.NODE_ENV
});
