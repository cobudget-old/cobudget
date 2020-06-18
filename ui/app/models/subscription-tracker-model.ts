/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('SubscriptionTrackerModel', function(BaseModel) {
  let SubscriptionTrackerModel;
  return SubscriptionTrackerModel = (function() {
    SubscriptionTrackerModel = class SubscriptionTrackerModel extends BaseModel {
      static initClass() {
        this.singular = 'subscriptionTracker';
        this.plural = 'subscriptionTrackers';
  
        this.serializableAttributes = [
          'subscribedToEmailNotifications',
          'emailDigestDeliveryFrequency'
        ];
      }

      relationships() {
        return this.belongsTo('user');
      }
    };
    SubscriptionTrackerModel.initClass();
    return SubscriptionTrackerModel;
  })();
});
