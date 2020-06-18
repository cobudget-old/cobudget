// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Loki from 'lokijs';

const app = cobudgetApp;

import AngularRecordStore from 'angular_record_store';

app.factory('BaseModel', AngularRecordStore.BaseModelFn);
app.factory('BaseRecordsInterface', ['RestfulClient', '$q', AngularRecordStore.BaseRecordsInterfaceFn]);
app.factory('RecordStore', AngularRecordStore.RecordStoreFn);
// $compile is a joke, actually $upload (current version used is 3.x, need to update, might not even need to use)
app.factory('RestfulClient', ['$http', '$compile', AngularRecordStore.RestfulClientFn]);

app.factory('Records', function(RecordStore, GroupRecordsInterface, BucketRecordsInterface, UserRecordsInterface, AllocationRecordsInterface, MembershipRecordsInterface, CommentRecordsInterface, ContributionRecordsInterface, SubscriptionTrackerRecordsInterface, AnnouncementRecordsInterface) {
  const db = new Loki('cobudgetApp');
  const recordStore = new RecordStore(db);
  recordStore.addRecordsInterface(GroupRecordsInterface);
  recordStore.addRecordsInterface(BucketRecordsInterface);
  recordStore.addRecordsInterface(UserRecordsInterface);
  recordStore.addRecordsInterface(AllocationRecordsInterface);
  recordStore.addRecordsInterface(MembershipRecordsInterface);
  recordStore.addRecordsInterface(CommentRecordsInterface);
  recordStore.addRecordsInterface(ContributionRecordsInterface);
  recordStore.addRecordsInterface(SubscriptionTrackerRecordsInterface);
  recordStore.addRecordsInterface(AnnouncementRecordsInterface);
  return recordStore;
});
