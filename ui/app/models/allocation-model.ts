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
cobudgetApp.factory('AllocationModel', function(BaseModel) {
  let AllocationModel;
  return AllocationModel = (function() {
    AllocationModel = class AllocationModel extends BaseModel {
      static initClass() {
        this.singular = 'allocation';
        this.plural = 'allocations';
        this.indices = ['groupId', 'userId'];
        this.serializableAttributes = ['groupId', 'userId', 'amount', 'notify', 'fromGroupAccount'];
      }

      relationships() {
        this.belongsTo('group');
        return this.belongsTo('user');
      }
    };
    AllocationModel.initClass();
    return AllocationModel;
  })();
});
