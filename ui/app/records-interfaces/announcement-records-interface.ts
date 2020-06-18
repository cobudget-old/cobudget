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
global.cobudgetApp.factory('AnnouncementRecordsInterface', function(config, BaseRecordsInterface, $q, AnnouncementModel) {
  let AnnouncementRecordsInterface;
  return AnnouncementRecordsInterface = (function() {
    AnnouncementRecordsInterface = class AnnouncementRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = AnnouncementModel;
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

      seen(params) {
        return this.remote.post('seen', params);
      }
    };
    AnnouncementRecordsInterface.initClass();
    return AnnouncementRecordsInterface;
  })();
});
