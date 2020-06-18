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
cobudgetApp.factory('ContributionModel', function(BaseModel) {
  let ContributionModel;
  return ContributionModel = (function() {
    ContributionModel = class ContributionModel extends BaseModel {
      static initClass() {
        this.singular = 'contribution';
        this.plural = 'contributions';
        this.indices = ['bucketId', 'userId'];
        this.serializableAttributes = ['amount', 'bucketId'];
      }

      relationships() {
        this.belongsTo('bucket');
        return this.belongsTo('user');
      }
    };
    ContributionModel.initClass();
    return ContributionModel;
  })();
});