var State = require('ampersand-state')

/* @ngInject */
module.exports = function () {
  return State.extend({
    modelType: 'User',

    props: {
      id: 'number',
      name: 'string',
      email: 'string',
      password: 'string'
    },
  });
}
