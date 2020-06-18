/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('ContributionRecordsInterface', function(config, BaseRecordsInterface, ContributionModel) {
  let ContributionRecordsInterface;
  return ContributionRecordsInterface = (function() {
    ContributionRecordsInterface = class ContributionRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = ContributionModel;
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

      fetchByBucketId(bucketId) {
        return this.fetch({
          params: {
            bucket_id: bucketId
          }
        });
      }

      fetchByGroupId(groupid) {
        return this.fetch({
          params: {
            group_id: groupid
          }
        });
      }
    };
    ContributionRecordsInterface.initClass();
    return ContributionRecordsInterface;
  })();
});
