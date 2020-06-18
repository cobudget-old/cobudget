/* eslint-disable
    babel/new-cap,
    no-shadow,
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
global.cobudgetApp.factory('UserCan', function(CurrentUser, $location, $q, Records, Toast) {
  let UserCan;
  return new (UserCan = class UserCan {
    viewGroup(group) {
      const validMemberships = Records.memberships.find({
        groupId: group.id,
        memberId: global.cobudgetApp.currentUserId,
      });
      return validMemberships.length === 1;
    }

    viewBucket(bucket) {
      return this.viewGroup(bucket.group());
    }

    editBucket(bucket) {
      const isBucketAuthor = bucket.userId === global.cobudgetApp.currentUserId;
      return isBucketAuthor || CurrentUser().isAdminOf(bucket.group());
    }

    viewAdminPanel() {
      const validMemberships = Records.memberships.find({
        memberId: global.cobudgetApp.currentUserId,
        isAdmin: true,
      });
      return validMemberships.length > 0;
    }

    changeEmailSettings() {
      return CurrentUser().isConfirmed();
    }

    manageFundsForGroup(group) {
      return CurrentUser().isAdminOf(group);
    }

    inviteMembersToGroup(group) {
      return this.manageFundsForGroup(group);
    }

    viewAnalyticsPage() {
      return CurrentUser().isSuperAdmin;
    }
  });
});
