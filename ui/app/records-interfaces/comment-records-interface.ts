/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null; 

/* @ngInject */
global.cobudgetApp.factory('CommentRecordsInterface', function(config, BaseRecordsInterface, CommentModel) { 
  let CommentRecordsInterface;
  return CommentRecordsInterface = (function() {
    CommentRecordsInterface = class CommentRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = CommentModel;
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
    };
    CommentRecordsInterface.initClass();
    return CommentRecordsInterface;
  })();
});
