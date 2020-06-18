/* eslint-disable
    babel/new-cap,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  url: '/email_settings?previous_group_id',
  resolve: {
    userValidated($auth) {
      return $auth.validateUser();
    },
    membershipsLoaded() {
      return cobudgetApp.membershipsLoaded;
    },
  },
  template: require('./email-settings-page.html'),
  reloadOnSearch: false,
  controller(CurrentUser, Dialog, Error, $location, Records, $scope, $stateParams, Toast, UserCan) {

    if (UserCan.changeEmailSettings()) {
      $scope.authorized = true;
      Error.clear();
    } else {
      $scope.authorized = false;
      Error.set("you can't view this page");
    }

    $scope.currentUser = CurrentUser();
    $scope.subscriptionTracker = $scope.currentUser.subscriptionTracker();
    const previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id;

    $scope.emailDigestDeliveryFrequencyOptions = ['never', 'daily', 'weekly'];

    $scope.cancel = function() {
      $location.search('previous_group_id', null);
      return $location.path(`/groups/${previousGroupId}`);
    };

    $scope.attemptCancel = function(emailSettingsForm) {
      if (emailSettingsForm.$dirty) {
        return Dialog.confirm({title: 'Discard unsaved changes?'})
          .then(() => $scope.cancel());
      } else {
        return $scope.cancel();
      }
    };

    $scope.save = () => Records.subscriptionTrackers.updateEmailSettings($scope.subscriptionTracker).then(function() {
      Toast.show('Email settings updated!');
      return $scope.cancel();
    });

  },
};
