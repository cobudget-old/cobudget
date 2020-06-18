/* eslint-disable
    no-undef,
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('onlyDigits', () => ({
  restrict: 'A',

  link(scope, el, attrs) {
    return el.bind('keypress', function(e) {
      const acceptableKeyCodes = _.range(48,58).concat([0, 8]);
      if (!_.includes(acceptableKeyCodes, e.which)) {
        return e.preventDefault();
      }
    });
  },
}));
