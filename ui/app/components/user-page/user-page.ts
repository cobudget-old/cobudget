/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  resolve: {
    userValidated($auth) {
      return $auth.validateUser();
    },
    membershipsLoaded() {
      return global.cobudgetApp.membershipsLoaded;
    }
  },
  url: '/users/:userId',
  template: require('./user-page.html'),
  controller(CurrentUser, Error, $location, Records, $scope, $stateParams, LoadBar) {

    LoadBar.start();

    const userId = parseInt($stateParams.userId);

    Records.users.fetchUserById(userId)
      .then(function(data) {
        LoadBar.stop();
        return $scope.user = data.user;}).catch(() => Error.set('user not found'));

  }
};
