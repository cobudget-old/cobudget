/* eslint-disable
    constructor-super,
    no-constant-condition,
    no-shadow,
    no-this-before-super,
    no-undef,
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
cobudgetApp.factory('SubscriptionTrackerRecordsInterface', function(config, BaseRecordsInterface, $q, SubscriptionTrackerModel) {
  let SubscriptionTrackerRecordsInterface;
  return SubscriptionTrackerRecordsInterface = (function() {
    SubscriptionTrackerRecordsInterface = class SubscriptionTrackerRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = SubscriptionTrackerModel;
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

      updateEmailSettings(subscriptionTracker) {
        const params = _.pick(subscriptionTracker, [
          'subscribedToEmailNotifications',
          'emailDigestDeliveryFrequency',
        ]);
        return this.remote.post('update_email_settings', { subscription_tracker: morph.toSnake(params) });
      }
    };
    SubscriptionTrackerRecordsInterface.initClass();
    return SubscriptionTrackerRecordsInterface;
  })();
});
