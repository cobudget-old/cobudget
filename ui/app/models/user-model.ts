/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('UserModel', function(BaseModel) {
  let UserModel;
  return UserModel = (function() {
    UserModel = class UserModel extends BaseModel {
      static initClass() {
        this.singular = 'user';
        this.plural = 'users';
  
        this.serializableAttributes = [
          'email',
          'name',
          'subscribedToPersonalActivity',
          'subscribedToDailyDigest',
          'subscribedToParticipantActivity',
          'confirmationToken',
          'isSuperAdmin'
        ];
      }

      relationships() {
        this.hasMany('memberships', {with: 'memberId'});
        this.belongsTo('subscriptionTracker');
        return this.hasMany('announcements', {with: 'announcementId'});
      }

      groups() {
        const groupIds = _.map(this.memberships(), membership => membership.groupId);
        return this.recordStore.groups.find(groupIds);
      }

      administeredGroups() {
        return _.filter(this.groups(), group => {
          return this.isAdminOf(group);
        });
      }

      isAGroupAdmin() {
        return this.administeredGroups().length > 0;
      }

      primaryGroup() {
        return this.groups()[0];
      }

      isAdminOf(group) {
        return !!_.find(this.memberships(), membership => (membership.groupId === group.id) && membership.isAdmin);
      }

      isConfirmed() {
        return !!this.confirmedAt;
      }

      hasEverJoinedAGroup() {
        return !!this.joinedFirstGroupAt;
      }

      hasMemberships() {
        return this.memberships().length > 0;
      }
    };
    UserModel.initClass();
    return UserModel;
  })();
});
