Loki = require('lokijs')

app = global.cobudgetApp

AngularRecordStore = require('angular_record_store')

app.factory('BaseModel', AngularRecordStore.BaseModel)
app.factory('BaseRecordsInterface', ['RestfulClient', '$q', AngularRecordStore.BaseRecordsInterface])
app.factory('RecordStore', AngularRecordStore.RecordStore)
app.factory('RestfulClient', ['$http', '$upload', AngularRecordStore.RestfulClient])

app.factory 'Records', ['RecordStore', 'GroupRecordsInterface', (RecordStore, GroupRecordsInterface) ->
  db = new Loki('cobudgetApp')
  recordStore = new RecordStore(db)
  recordStore.addRecordsInterface(GroupRecordsInterface)
  recordStore
]