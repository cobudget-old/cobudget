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
  url: '/groups/:groupId/manage_funds/review_upload',
  template: require('./review-bulk-allocation-page.html'),
  params: {
    people: null,
    groupId: null
  },
  controller(config, CurrentUser, Dialog, Error, LoadBar, $location, $q, Records, $scope, $state, $stateParams, $timeout, UserCan) {

    $scope.uploadStatus = 'standby';

    LoadBar.start();
    const groupId = parseInt($stateParams.groupId);
    if (!$stateParams.people) {
      $location.path(`/groups/${groupId}/manage_funds`);
    }

    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        LoadBar.stop();
        if (UserCan.manageFundsForGroup(group)) {
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

    $scope.abs = val => Math.abs(val);

    $scope.preparePeopleList = function() {
      $scope.people = _.map($stateParams.people, function(person) {
        person.deferred = $q.defer();
        person.allocation_amount = parseFloat(person.allocation_amount);
        return person;
      });
      $scope.peopleWithPositiveAllocations = [];
      $scope.newMembers = [];
      $scope.existingMembers = [];
      return _.each($scope.people, function(person) {
        if (person.allocation_amount > 0) {
          $scope.peopleWithPositiveAllocations.push(person);
        }
        if (person.new_member) {
          return $scope.newMembers.push(person);
        } else {
          return $scope.existingMembers.push(person);
        }
      });
    };

    $scope.summedAllocationsFrom = function(people) {
      const callback = (sum, person) => sum + Math.abs(parseFloat(person.allocation_amount));
      return _.reduce(people, callback, 0);
    };

    $scope.openUploadCSVPrimerDialog = function() {
      const uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
        scope: $scope
      });
      return Dialog.open(uploadCSVPrimerDialog);
    };

    $scope.cancel = () => $location.path(`/groups/${groupId}`);

    // TODO: eww - definitely refactor
    $scope.confirmBulkAllocations = function() {
      $scope.uploadStatus = 'pending';
      const promises = _.map($scope.people, person => person.deferred.promise);

      _.each($scope.newMembers, function(newMember) {
        newMember.status = 'pending';
        const membershipParams = {group_id: groupId, email: newMember.email.toLowerCase()};
        return Records.memberships.remote.create(membershipParams).then(function(data) {
          const newMembership = data.memberships[0];
          if (newMember.allocation_amount !== 0) {
            const allocationParams = {groupId, userId: data.users[0].id, amount: newMember.allocation_amount, notify: newMember.notify};
            const allocation = Records.allocations.build(allocationParams);
            return allocation.save().then(() => Records.memberships.invite(newMembership).then(function() {
              newMember.status = 'complete';
              return newMember.deferred.resolve();
            }));
          } else {
            return Records.memberships.invite(newMembership).then(function() {
              newMember.status = 'complete';
              return newMember.deferred.resolve();
            });
          }
        });
      });

      _.each($scope.existingMembers, function(existingMember) {
        existingMember.status = 'pending';
        if (existingMember.allocation_amount !== 0) {
          const params = {groupId, userId: existingMember.id, amount: existingMember.allocation_amount, notify: existingMember.notify};
          const allocation = Records.allocations.build(params);
          return allocation.save().then(function() {
            existingMember.status = 'complete';
            return existingMember.deferred.resolve();
          });
        } else {
          existingMember.status = 'complete';
          return existingMember.deferred.resolve();
        }
      });

      return $q.allSettled(promises).then(() => $scope.uploadStatus = 'complete');
    };

    $scope.done = () => $scope.cancel();

    $scope.seeAllMembers = () => $state.go('group', {groupId, tab: 'funders'});

  }
};
