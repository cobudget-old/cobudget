/* eslint-disable
    no-shadow,
    no-undef,
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
cobudgetApp.factory('BucketModel', function(BaseModel) {
  let BucketModel;
  return BucketModel = (function() {
    BucketModel = class BucketModel extends BaseModel {
      static initClass() {
        this.singular = 'bucket';
        this.plural = 'buckets';
        this.indices = ['groupId', 'userId'];
        this.serializableAttributes = ['description', 'name', 'target', 'groupId'];
      }

      relationships() {
        this.hasMany('comments', {sortBy: 'createdAt', sortDesc: false});
        this.hasMany('contributions', {sortBy: 'createdAt', sortDesc: false});
        this.belongsTo('group');
        return this.belongsTo('author', {from: 'users', by: 'userId'});
      }

      amountRemaining() {
        return this.target - this.totalContributions;
      }

      percentFunded() {
        return (this.totalContributions / this.target) * 100;
      }

      openForFunding() {
        return this.remote.postMember(this.id, 'open_for_funding');
      }

      cancel() {
        return this.remote.postMember(this.id, 'archive');
      }

      complete() {
        return this.remote.postMember(this.id, 'paid');
      }

      hasComments() {
        return this.numOfComments > 0;
      }

      contributionsByUser(user) {
        return this.recordStore.contributions.find({bucketId: this.id, userId: user.id});
      }

      amountContributedByUser(user) {
        return _.sum(this.contributionsByUser(user), contribution => contribution.amount);
      }

      amountContributedByOthers(user) {
        return this.totalContributions - this.amountContributedByUser(user);
      }

      percentContributedByOthers(user) {
        return (this.amountContributedByOthers(user) / this.target) * 100;
      }

      percentContributedByUser(user) {
        return (this.amountContributedByUser(user) / this.target) * 100;
      }

      isArchived() {
        return !!this.archivedAt && !this.paidAt;
      }

      isIdea() {
        return (this.status === 'draft') && !this.archivedAt;
      }

      isFunding() {
        return (this.status === 'live') && !this.archivedAt;
      }

      isFunded() {
        return (this.status === 'funded') && !this.paidAt;
      }

      isComplete() {
        return !!this.paidAt && (this.status === 'funded');
      }

      isCancelled() {
        return !!this.archivedAt && !this.paidAt && (this.status !== 'funded');
      }

      //# Legacy funded and archived bucket
      isFundedAndArchived() {
        return (this.status === 'funded') && !this.paidAt && !!this.archivedAt;
      }
    };
    BucketModel.initClass();
    return BucketModel;
  })();
});
