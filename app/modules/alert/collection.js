var Collection = require('ampersand-collection')

/* @ngInject */
global.cobudgetApp.factory('AlertCollection', function (AlertModel) {
  return Collection.extend({
    model: AlertModel
  })
})