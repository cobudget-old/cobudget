/* eslint-disable
    babel/new-cap,
    no-shadow,
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
cobudgetApp.directive('groupPageFunders', () => ({
  restrict: 'E',
  template: require('./group-page-funders.html'),
  replace: true,

  controller(config, Dialog, DownloadCSV, LoadBar, $q, Records, $scope, Toast, $window) {

    Records.memberships.fetchByGroupId($scope.group.id).then(() => $scope.fundersLoaded = true);

    console.log($scope.group.settledMemberships());

    $scope.toggleMemberAdmin = function(membership) {
      membership.isAdmin = !membership.isAdmin;
      const params = {
        membership: {
          is_admin: membership.isAdmin,
        },
      };
      return membership.remote.update(membership.id, params);
    };

    $scope.downloadCSV = function() {
      const timestamp = moment().format('YYYY-MM-DD-HH-mm-ss');
      const filename = `${$scope.group.name}-member-data-${timestamp}`;
      const params = {
        url: `${config.apiPrefix}/memberships.csv?group_id=${$scope.group.id}`,
        filename,
      };
      return DownloadCSV(params);
    };

    $scope.openResendInvitesDialog = () => Dialog.confirm({
      content: `Resend invitations to ${$scope.group.pendingMemberships().length} people?`,
    }).then(() => $scope.resendInvites());

    $scope.resendInvites = function() {
      let invitesSent = 0;
      LoadBar.start({msg: `Resending invites (0 / ${$scope.group.pendingMemberships().length})`});
      const promises = [];
      _.each($scope.group.pendingMemberships(), function(membership) {
        const promise = Records.memberships.invite(membership);
        promise.finally(function() {
          invitesSent = invitesSent + 1;
          return LoadBar.updateMsg(`Resending invites (${invitesSent} / ${$scope.group.pendingMemberships().length})`);
        });
        return promises.push(promise);
      });

      return $q.allSettled(promises).finally(function() {
        Toast.show(`${promises.length} invitations sent!`);
        return LoadBar.stop();
      });
    };

    // TODO: refactor
    $scope.inviteAgain = membership => Dialog.custom({
      template: require('./reinvite-user-dialog.tmpl.html'),
      scope: $scope,
      controller(Dialog, $mdDialog, Records, $scope, Toast) {
        $scope.member = membership.member();
        $scope.cancel = () => $mdDialog.cancel();
        return $scope.proceed = () => Records.memberships.invite(membership)
          .then(function() {
            $scope.cancel();
            return Toast.show('Invitation sent!');}).catch(() => Dialog.alert({title: 'Error!'}));
      },
    });

    $scope.removeMembership = function(membership) {
      const removeMembershipDialog = require('./../../components/remove-membership-dialog/remove-membership-dialog.coffee')({
        scope: $scope,
        membership,
      });
      return Dialog.open(removeMembershipDialog);
    };


    // TODO: refactor
    $scope.openManageFundsDialog = (funderMembership, group) => Dialog.custom({
      scope: $scope,
      template: require('./../../directives/group-page-funders/manage-funds-dialog.tmpl.html'),
      controller($mdDialog, $scope, Records) {
        $scope.formData = {};
        $scope.mode = 'add';
        $scope.formData.fromGroupAccount = false;

        $scope.managedMembership = funderMembership;
        $scope.managedMember = funderMembership.member();
        $scope.group = group;

        $scope.setMode = mode => $scope.mode = mode;

        // for 'add' mode
        $scope.normalizeAllocationAmount = function() {
          const allocationAmount = $scope.formData.allocationAmount || 0;
          if ((allocationAmount + $scope.managedMembership.rawBalance) < 0) {
            $scope.formData.allocationAmount = -$scope.managedMembership.rawBalance;
          }
          // if money should come from group account, set the groupAccountBalance as the upper limit
          if ($scope.formData.fromGroupAccount) {
            if (allocationAmount > $scope.group.groupAccountBalance) {
              return $scope.formData.allocationAmount = $scope.group.groupAccountBalance;
            }
          }
        };


        // for 'change' mode
        $scope.normalizeNewBalance = function() {
          if ($scope.formData.newBalance < 0) {
            return $scope.formData.newBalance = 0;
          }
        };

        $scope.isValidForm = () => (($scope.mode === 'add') && $scope.formData.allocationAmount) || (($scope.mode === 'change') && ( $scope.formData.newBalance || ($scope.formData.newBalance === 0)));

        $scope.transferFromGroupAccount = () => // if checked, renormalize
        $scope.normalizeAllocationAmount();

        $scope.cancel = () => $mdDialog.cancel();

        return $scope.createAllocation = function() {
          let amount;
          if ($scope.mode === 'add') {
            amount = $scope.formData.allocationAmount;
          }
          if ($scope.mode === 'change') {
            amount = $scope.formData.newBalance - $scope.managedMembership.rawBalance;
          }
          const params = {groupId: $scope.group.id, userId: $scope.managedMember.id, amount, fromGroupAccount: $scope.formData.fromGroupAccount, notify: true };
          const allocation = Records.allocations.build(params);
          return allocation.save()
            .then(function(res) {
              Records.memberships.findOrFetchById($scope.managedMembership.id);
              return Dialog.alert({title: 'Success!'});}).catch(err => Dialog.alert({title: 'Error!'})).finally(() => $scope.cancel());
        };
      },
    });

  },
}));
