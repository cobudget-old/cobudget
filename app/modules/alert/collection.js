var Collection = require('ampersand-collection')

/* @ngInject */
module.exports = function (AlertModel) {
  return Collection.extend({
    model: AlertModel
  })
}
