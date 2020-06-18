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
  resolve: {
    userValidated($auth) {
      return $auth.validateUser();
    },
    membershipsLoaded() {
      return cobudgetApp.membershipsLoaded;
    },
  },
  url: '/groups/:groupId/invite_members',
  template: require('./invite-members-page.html'),
  controller(config, CurrentUser, Dialog, DownloadCSV, Error, $location, LoadBar, Records, $scope, $state, $stateParams, Toast, UserCan) {

    LoadBar.start();
    const groupId = parseInt($stateParams.groupId);
    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        LoadBar.stop();
        if (UserCan.inviteMembersToGroup(group)) {
          $scope.authorized = true;
          Error.clear();
          $scope.group = group;
          $scope.currentUser = CurrentUser();
          return Records.memberships.fetchByGroupId(groupId);
        } else {
          $scope.authorized = false;
          return Error.set("you can't view this page");
        }}).catch(function() {
        LoadBar.stop();
        return Error.set('group not found');
    });

    $scope.openInviteMembersPrimerDialog = function() {
      const inviteMembersPrimerDialog = require('./../bulk-invite-members-primer-dialog/bulk-invite-members-primer-dialog.coffee')({
        scope: $scope,
      });
      return Dialog.open(inviteMembersPrimerDialog);
    };

    $scope.redirectToManageGroupFundsPage = function() {
      Dialog.close();
      return $location.path(`/groups/${groupId}/manage_funds`);
    };

    $scope.cancel = () => $location.path(`/groups/${groupId}`);

    $scope.inviteMemberFormParams = {group_id: groupId};

    $scope.inviteMember = () => Records.memberships.remote.create($scope.inviteMemberFormParams)
      .then(function(data) {
        const newMembership = data.memberships[0];
        return Records.memberships.invite(newMembership).then(function() {
          $state.reload();
          return Toast.show('Invitation sent!');
        });}).catch(() => Dialog.alert({title: 'error!', content: 'member already exists'}));

  },
};
