module.exports = function (options) {
  return {
    template: require('./forgot-confirmed-template.html'),
    controller: require('./forgot-confirmed-controller'),
    size: 'lg',
    resolve: {
      user: function () {
        return options.user;
      },
    },
  };
};
