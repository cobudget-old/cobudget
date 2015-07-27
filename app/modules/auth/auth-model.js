var debug = require('debug')('auth:model');

/* @ngInject */
module.exports = function ($rootScope, authCookie, UserModel, $location) {
  return UserModel.extend({

    props: {
      accessToken: 'string',
      initialized: 'boolean',
      resetPasswordToken: 'string',
    },

    initialize: function () {
      UserModel.prototype.initialize.apply(this, arguments);

      this.set(authCookie.get());
    },

    set: function () {
      UserModel.prototype.set.apply(this, arguments);
      authCookie.put(this.toJSON())
    },

    clear: function () {
      authCookie.del();
      UserModel.prototype.clear.apply(this, arguments);
    },
  });
};
