var recase = require('recase').create({})

/* @ngInject */
module.exports = function ($httpProvider) {

  $httpProvider.defaults.withCredentials = true;

  $httpProvider.defaults.transformResponse = appendTransform(
    $httpProvider.defaults.transformResponse,
    function (data) {
      return (data && typeof data === 'object') ?
        recase.camelCopy(data) : data
      ;
    }
  );

  $httpProvider.defaults.transformRequest = appendTransform(
    function (data) {
      return (data && typeof data === 'object') ?
        recase.snakeCopy(data) : data
      ;
    },
    $httpProvider.defaults.transformRequest
  );
}

function appendTransform(defaults, transform) {

  // we can't guarantee that the default transformation is an array
  defaults = angular.isArray(defaults) ? defaults : [defaults];

  // append the new transformation to the defaults
  return defaults.concat(transform);
}
