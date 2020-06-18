/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('CommentModel', function(BaseModel) {
  let CommentModel;
  return CommentModel = (function() {
    CommentModel = class CommentModel extends BaseModel {
      static initClass() {
        this.singular = 'comment';
        this.plural = 'comments';
        this.indices = ['bucketId', 'userId'];
        this.serializableAttributes = ['bucketId', 'body'];
      }

      relationships() {
        this.belongsTo('author', {from: 'users', by: 'userId'});
        return this.belongsTo('bucket');
      }
    };
    CommentModel.initClass();
    return CommentModel;
  })();
});
