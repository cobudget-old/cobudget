// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */

cobudgetApp.directive('contenteditable', $sce => ({
  restrict: 'A',
  require: '?ngModel',

  link(scope, element, attrs, ngModel) {

    const read = function() {
      let html = element.html();
      // When we clear the content editable the browser leaves a <br> behind
      // If strip-br attribute is provided then we strip this out
      if (attrs.stripBr && (html === '<br>')) {
        html = '';
      }
      ngModel.$setViewValue(html);
    };

    if (!ngModel) {
      return;
    }
    // do nothing if no ng-model
    // Specify how UI should be updated

    ngModel.$render = function() {
      if (ngModel.$viewValue !== element.html()) {
        element.html($sce.getTrustedHtml(ngModel.$viewValue || ''));
      }
    };

    // Listen for change events to enable binding
    element.on('blur keyup change', function() {
      scope.$apply(read);
    });
    read();
    // initialize
  },
}));
