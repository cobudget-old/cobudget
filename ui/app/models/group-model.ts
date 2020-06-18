/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('GroupModel', function(BaseModel) {
  let GroupModel;
  return GroupModel = (function() {
    GroupModel = class GroupModel extends BaseModel {
      static initClass() {
        this.singular = 'group';
        this.plural = 'groups';
        this.serializableAttributes = ['name', 'currencyCode', 'currencySymbol', 'description', 'initialized', 'fundingFreeze', 'addFunds'];
      }

      relationships() {
        this.hasMany('buckets');
        this.hasMany('allocations');
        return this.hasMany('memberships', {sortBy: 'createdAt', sortDesc: false});
      }

      draftBuckets() {
        return this.getBuckets((bucket => bucket.isIdea()), 'createdAt');
      }

      liveBuckets() {
        return this.getBuckets((bucket => bucket.isFunding()), 'liveAt');
      }

      fundedBuckets() {
        return this.getBuckets((bucket => bucket.isFunded()), 'fundedAt');
      }

      completedBuckets() {
        return this.completeBuckets();
      }

      completeBuckets() {
        return this.getBuckets((bucket => bucket.isComplete()), 'paidAt');
      }

      cancelledBuckets() {
        return this.getBuckets((bucket => bucket.isCancelled()), 'archivedAt');
      }

      fundedCompletedBuckets() {
        return this.getBuckets((bucket => bucket.isFunded() || bucket.isComplete()), 'fundedAt');
      }

      pendingMemberships() {
        return _.filter(this.memberships(), membership => membership.isPending());
      }

      settledMemberships() {
        return _.filter(this.memberships(), membership => !membership.isPending());
      }

      // hasManyThrough doesn't yet exist quite yet
      members() {
        return _.map(this.memberships(), membership => membership.member());
      }

      membershipFor(member) {
        return _.first(_.filter(this.memberships(), membership => membership.memberId === member.id)
        );
      }

      // private
      filterBucketsByFunction(fun) {
        return _.filter(this.buckets(), fun);
      }

      getBuckets(fun, datePropToSortBy) {
        const filteredBuckets = this.filterBucketsByFunction(fun);
        return _.sortBy(filteredBuckets, bucket => bucket[datePropToSortBy].format()).reverse();
      }
    };
    GroupModel.initClass();
    return GroupModel;
  })();
});
