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
  url: '/profile_settings?previous_group_id',
  template: require('./profile-settings-page.html'),
  reloadOnSearch: false,
  controller(CurrentUser, Dialog, $location, $q, Records, $scope, $stateParams, Toast, $window) {
    $scope.currentUser = CurrentUser();
    const previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id;
    $scope.passwordParams = {};

    $scope.back = function() {
        $location.search('previous_group_id', null);
        return $location.path(`/groups/${previousGroupId}`);
      };

    $scope.attemptBack = function() {
      if ($scope.accountDetailsForm.$dirty) {
        return Dialog.custom({
          scope: $scope,
          template: require('./discard-changes-dialog.tmpl.html'),
          controller($mdDialog, $scope) {
            $scope.cancel = () => $mdDialog.cancel();
            return $scope.okay = function() {
              $mdDialog.cancel();
              return $scope.back();
            };
          }
        });

      } else {
        return $scope.back();
      }
    };

    $scope.openPasswordFields = () => $scope.showPasswordFields = true;

    $scope.closePasswordFields = function() {
      $scope.passwordParams = {};
      $scope.passwordErrors = {};
      $scope.showPasswordFields = false;
      _.each(['current_password', 'password', 'confirm_password'], fieldName => $scope.accountDetailsForm[fieldName].$setPristine());
      if ($scope.accountDetailsForm.name.$pristine) {
        return $scope.accountDetailsForm.$setPristine();
      }
    };

    $scope.save = function() {
      $scope.formSubmitted = true;
      const promises = [];
      if ($scope.accountDetailsForm.name.$dirty) {
        promises.push($scope.updateProfile());
      }
      if ($scope.showPasswordFields) {
        promises.push($scope.savePassword());
      }
      return $q.allSettled(promises)
        .then(function() {
          let formSubmitted;
          return formSubmitted = false;}).finally(function() {
          const resolvedPromises = _.filter(promises, promise => promise.$$state.status === 1);
          const updatedFields = _.map(resolvedPromises, promise => promise.$$state.value);
          if (updatedFields.length > 0) {
            return Toast.show(`Your new ${updatedFields} ${updatedFields.length > 1 ? 'were' : 'was'} saved`);
          }
      });
    };

    $scope.updateProfile = function() {
      const deferred = $q.defer();
      const profileParams = _.pick($scope.currentUser, ['name']);
      Records.users.updateProfile(profileParams)
        .then(() => deferred.resolve('name')).catch(() => deferred.reject());
      return deferred.promise;
    };

    return $scope.savePassword = function() {
      const deferred = $q.defer();
      $scope.passwordErrors = {};
      Records.users.updatePassword($scope.passwordParams)
        .then(function(res) {
          $scope.closePasswordFields();
          return deferred.resolve('password');}).catch(function(err) {
          if (err.status === 401) {
            $scope.passwordErrors.currentPassword = 'Sorry, we couldn\'t confirm your current password.';
            $scope.passwordParams.current_password = "";
          } else if (err.status === 400) {
            $scope.passwordErrors.newPassword = 'Sorry, your repeated new password didn\'t match.';
            $scope.passwordParams.password = "";
            $scope.passwordParams.confirm_password = "";
          }
          return deferred.reject();
      });
      return deferred.promise;
    };
  }
};
