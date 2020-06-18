/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('Toast', function($mdToast, $location) {
  let Toast;
  return new (Toast = class Toast {

    show(msg) {
      const toast = $mdToast.simple()
        .content(msg);
      return $mdToast.show(toast);
    }

    showWithRedirect(msg, path) {
      const toast = $mdToast.simple()
        .content(msg)
        .action('VIEW')
        .highlightAction(false);

      return $mdToast.show(toast).then(function(res) {
        if (res === 'ok') {
          return $location.path(path);
        }
      });
    }

    hide() {
      return angular.element('md-toast').hide();
    }
  });
});