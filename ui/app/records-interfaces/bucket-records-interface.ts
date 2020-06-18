/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null; 

/* @ngInject */
global.cobudgetApp.factory('BucketRecordsInterface', function(config, BaseRecordsInterface, BucketModel) { 
  let BucketRecordsInterface;
  return BucketRecordsInterface = (function() {
    BucketRecordsInterface = class BucketRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = BucketModel;
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
            group_id: groupId
          }
        });
      }
    };
    BucketRecordsInterface.initClass();
    return BucketRecordsInterface;
  })();
});