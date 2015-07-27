var State = require('ampersand-state')

/* @ngInject */
module.exports = function () {
  return State.extend({
    props: {
      type: "string",
      msg: "string"
    },
  })
}
