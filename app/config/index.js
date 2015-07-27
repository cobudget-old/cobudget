var assign = require('lodash').assign

var defaults = require('../../config/defaults')
var config = require('../../config/' + (process.env.NODE_ENV || 'development'))

module.exports = assign({}, defaults, config, {
  env: process.env.NODE_ENV,
});
