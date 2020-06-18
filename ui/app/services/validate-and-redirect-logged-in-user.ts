/* eslint-disable
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

global.cobudgetApp.factory('ValidateAndRedirectLoggedInUser', ($auth, Error, LoadBar, $location, Records) => (function() {
  LoadBar.start();
  Error.clear();
  return $auth.validateUser()
    .then(() => global.cobudgetApp.membershipsLoaded.then(function(data) {
    const groupId = data.groups[0].id;
    $location.path(`/groups/${groupId}`);
    return LoadBar.stop();
  })).catch(() => LoadBar.stop());
}));
