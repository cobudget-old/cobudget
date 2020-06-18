/* eslint-disable
    constructor-super,
    no-constant-condition,
    no-shadow,
    no-this-before-super,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null; 

/* @ngInject */
cobudgetApp.factory('AllocationRecordsInterface', function(config, BaseRecordsInterface, AllocationModel) { 
  let AllocationRecordsInterface;
  return AllocationRecordsInterface = (function() {
    AllocationRecordsInterface = class AllocationRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = AllocationModel;
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
      fetchByGroupId(groupId) {
        return this.fetch({
          params: {
            group_id: groupId,
          },
        });
      }
    };
    AllocationRecordsInterface.initClass();
    return AllocationRecordsInterface;
  })();
});