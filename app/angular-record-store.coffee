Loki = require('lokijs')

app = global.cobudgetApp

AngularRecordStore = require('angular_record_store')

app.factory('BaseModel', AngularRecordStore.BaseModel)
app.factory('BaseRecordsInterface', ['RestfulClient', '$q', AngularRecordStore.BaseRecordsInterface])
app.factory('RecordStore', AngularRecordStore.RecordStore)
# $compile is a joke, actually $upload (current version used is 3.x, need to update, might not even need to use)
app.factory('RestfulClient', ['$http', '$compile', AngularRecordStore.RestfulClient])

app.factory 'Records', (RecordStore, GroupRecordsInterface, BucketRecordsInterface) ->
  db = new Loki('cobudgetApp')
  recordStore = new RecordStore(db)
  recordStore.addRecordsInterface(GroupRecordsInterface)
  recordStore.addRecordsInterface(BucketRecordsInterface)
  recordStore.addRecordsInterface(UserRecordsInterface)
  recordStore
