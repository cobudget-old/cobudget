var State = require('ampersand-state')

/* @ngInject */
global.cobudgetApp.factory('AlertModel', function () {
  return State.extend({
    props: {
      type: "string",
      msg: "string"
    },
  })
});