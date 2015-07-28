var State = require('ampersand-state')

/* @ngInject */
global.cobudgetApp.factory('UserModel', function () {
  return State.extend({
    modelType: 'User',

    props: {
      id: 'number',
      name: 'string',
      email: 'string',
      password: 'string'
    },
  });
});