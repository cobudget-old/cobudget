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
global.cobudgetApp.factory('AnnouncementModel', function(BaseModel) {
  let AnnouncementModel;
  return AnnouncementModel = (function() {
    AnnouncementModel = class AnnouncementModel extends BaseModel {
      static initClass() {
        this.singular = 'announcement';
        this.plural = 'announcements';
        this.indices = ['announcementId'];
        this.serializableAttributes = [
          'title',
          'body',
          'url',
          'userIds',
        ];
      }

      relationships() {
        return this.hasMany('users');
      }
    };
    AnnouncementModel.initClass();
    return AnnouncementModel;
  })();
});
