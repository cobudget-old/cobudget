/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('GroupRecordsInterface', function(config, BaseRecordsInterface, GroupModel) { 
  let GroupRecordsInterface;
  return GroupRecordsInterface = (function() {
    GroupRecordsInterface = class GroupRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = GroupModel;
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

      getAll() {
        return this.remote.getCollection().then(data => camelize(data.groups));
      }
    };
    GroupRecordsInterface.initClass();
    return GroupRecordsInterface;
  })();
});