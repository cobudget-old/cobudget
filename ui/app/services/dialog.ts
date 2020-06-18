/* eslint-disable
    eqeqeq,
    no-shadow,
    no-undef,
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
cobudgetApp.factory('Dialog', function($mdDialog) {
  let Dialog;
  return new (Dialog = class Dialog {

    alert(args) {
      if (args == null) { args = {}; }
      const alert = $mdDialog.alert({
        title: args.title,
        content: args.content,
        ok: args.ok || 'ok',
      });
      return $mdDialog.show(alert);
    }

    confirm(args) {
      if (args == null) { args = {}; }
      const confirm = $mdDialog.confirm({
        title: args.title,
        content: args.content,
        ok: args.ok || 'ok',
        cancel: args.cancel || 'cancel',
      });
      return $mdDialog.show(confirm);
    }

    custom(args) {
      if (args == null) { args = {}; }
      const defaults = {
        clickOutsideToClose: true,
        preserveScope: true,
      };
      const custom = _.merge(defaults, args);
      return $mdDialog.show(custom);
    }

    close() {
      return $mdDialog.cancel();
    }

    open(component) {
      return this.custom(component);
    }
  });
});
