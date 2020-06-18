/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('MembershipRecordsInterface', function(config, BaseRecordsInterface, MembershipModel) {
  let MembershipRecordsInterface;
  return MembershipRecordsInterface = (function() {
    MembershipRecordsInterface = class MembershipRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = MembershipModel;
      }

      constructor(recordStore) {
        {
          // Hack: trick Babel/TypeScript into allowing this before super.
          if (false) { super(); }
          let thisFn = (() => { return this; }).toString();
          let thisName = thisFn.match(/return (?:_assertThisInitialized\()*(\w+)\)*;/)[1];
          eval(`${thisName} = this;`);
        }
        this.baseConstructor(recordStore);
        this.remote.apiPrefix = config.apiPrefix;
      }

      fetchMyMemberships() {
        return this.fetch({
          path: 'my_memberships'});
      }

      fetchMyMembershipsSuper(groupId) {
        return this.fetch({
          path: 'my_memberships',
          params: {
            group_id: groupId
          }
        });
      }

      fetchByGroupId(groupId) {
        return this.fetch({
          params: {
            group_id: groupId
          }
        });
      }

      invite(membership) {
        return this.remote.postMember(membership.id, 'invite');
      }
    };
    MembershipRecordsInterface.initClass();
    return MembershipRecordsInterface;
  })();
});
