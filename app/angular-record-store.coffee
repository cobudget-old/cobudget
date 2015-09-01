Loki = require('lokijs')

app = global.cobudgetApp

AngularRecordStore = require('angular_record_store')

app.factory('BaseModel', AngularRecordStore.BaseModelFn)
app.factory('BaseRecordsInterface', ['RestfulClient', '$q', AngularRecordStore.BaseRecordsInterfaceFn])
app.factory('RecordStore', AngularRecordStore.RecordStoreFn)
# $compile is a joke, actually $upload (current version used is 3.x, need to update, might not even need to use)
app.factory('RestfulClient', ['$http', '$compile', AngularRecordStore.RestfulClientFn])

app.factory 'Records', (RecordStore, GroupRecordsInterface, BucketRecordsInterface, UserRecordsInterface, AllocationRecordsInterface, MembershipRecordsInterface, CommentRecordsInterface, ContributionRecordsInterface) ->
  db = new Loki('cobudgetApp')
  recordStore = new RecordStore(db)
  recordStore.addRecordsInterface(GroupRecordsInterface)
  recordStore.addRecordsInterface(BucketRecordsInterface)
  recordStore.addRecordsInterface(UserRecordsInterface)
  recordStore.addRecordsInterface(AllocationRecordsInterface)
  recordStore.addRecordsInterface(MembershipRecordsInterface)
  recordStore.addRecordsInterface(CommentRecordsInterface)  
  recordStore.addRecordsInterface(ContributionRecordsInterface)  
  recordStore