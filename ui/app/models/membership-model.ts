/* eslint-disable
    no-shadow,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
cobudgetApp.factory('MembershipModel', function(BaseModel) {
  let MembershipModel;
  return MembershipModel = (function() {
    MembershipModel = class MembershipModel extends BaseModel {
      static initClass() {
        this.singular = 'membership';
        this.plural = 'memberships';
        this.indices = ['groupId', 'memberId'];
        this.serializableAttributes = ['isAdmin', 'closedAdminHelpCardAt', 'closedMemberHelpCardAt'];
      }

      relationships() {
        this.belongsTo('member', {from: 'users'});
        return this.belongsTo('group');
      }

      isPending() {
        return !this.member().isConfirmed();
      }

      cancel() {
        return this.remote.postMember(this.id, 'archive');
      }
    };
    MembershipModel.initClass();
    return MembershipModel;
  })();
});
