module.exports = function () {
  return {
    template: require('./login-template.html'),
    controller: require('./login-controller'),
    size: 'lg',
  };
};
