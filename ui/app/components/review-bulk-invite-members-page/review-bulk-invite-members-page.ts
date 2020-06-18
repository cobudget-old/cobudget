/* eslint-disable
    babel/new-cap,
    no-undef,
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
      return global.cobudgetApp.membershipsLoaded;
    },
  },
  url: '/groups/:groupId/invite_members/review_upload',
  template: require('./review-bulk-invite-members-page.html'),
  params: {
    people: null,
    groupId: null,
  },
  controller(config, CurrentUser, Dialog, Error, LoadBar, $location, $q, Records, $scope, $state, $stateParams, $timeout, UserCan) {

    $scope.uploadStatus = 'standby';

    LoadBar.start();
    const groupId = parseInt($stateParams.groupId);
    if (!$stateParams.people) {
      $location.path(`/groups/${groupId}/invite_members`);
    }

    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        LoadBar.stop();
        if (UserCan.inviteMembersToGroup(group)) {
          $scope.authorized = true;
          Error.clear();
          $scope.group = group;
          $scope.currentUser = CurrentUser();
          Records.memberships.fetchByGroupId(groupId);
          return $scope.preparePeopleList();
        } else {
          $scope.authorized = false;
          return Error.set("you can't view this page");
        }}).catch(function() {
        LoadBar.stop();
        return Error.set('group not found');
    });

    $scope.preparePeopleList = function() {
      $scope.people = _.map($stateParams.people, function(person) {
        person.deferred = $q.defer();
        return person;
      });
      $scope.newMembers = [];
      $scope.existingMembers = [];
      return _.each($scope.people, function(person) {
        if (person.new_member) {
          return $scope.newMembers.push(person);
        } else {
          return $scope.existingMembers.push(person);
        }
      });
    };

    $scope.openUploadCSVPrimerDialog = function() {
      const uploadCSVPrimerDialog = require('./../bulk-invite-members-primer-dialog/bulk-invite-members-primer-dialog.coffee')({
        scope: $scope,
      });
      return Dialog.open(uploadCSVPrimerDialog);
    };

    $scope.cancel = () => $location.path(`/groups/${groupId}`);

    $scope.confirmBulkInvites = function() {
      $scope.uploadStatus = 'pending';
      const promises = _.map($scope.people, person => person.deferred.promise);

      _.each($scope.newMembers, function(newMember) {
        newMember.status = 'pending';
        const params = {group_id: groupId, email: newMember.email.toLowerCase()};
        return Records.memberships.remote.create(params).then(function(data) {
          const newMembership = data.memberships[0];
          return Records.memberships.invite(newMembership).then(function() {
            newMember.status = 'complete';
            return newMember.deferred.resolve();
          });
        });
      });

      _.each($scope.existingMembers, function(existingMember) {
        existingMember.status = 'complete';
        return existingMember.deferred.resolve();
      });

      return $q.allSettled(promises).then(() => $scope.uploadStatus = 'complete');
    };

    $scope.done = () => $scope.cancel();

    $scope.seeAllMembers = () => $state.go('group', {groupId, tab: 'funders'});


  },
};
