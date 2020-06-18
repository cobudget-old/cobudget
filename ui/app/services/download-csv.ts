/* eslint-disable
    no-undef,
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

global.cobudgetApp.factory('DownloadCSV', $http => params => $http({
  method: 'GET',
  url: params.url}).then(function(response) {
  const anchor = angular.element('<a/>');
  angular.element(document.body).append(anchor);
  anchor.attr({
    href: 'data:attachment/csv;charset=utf-8,' + encodeURI(response.data),
    target: '_self',
    download: params.filename + '.csv'})[0].click();
  return anchor.remove();
}));
