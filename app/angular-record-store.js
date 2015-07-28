var app = global.cobudgetApp;

var AngularRecordStore = require('angular_record_store')

app.factory('BaseModel', AngularRecordStore.BaseModel);
app.factory('BaseRecordsInterface', ['RestfulClient', '$q', AngularRecordStore.BaseRecordsInterface]);
app.factory('RecordsStore', AngularRecordStore.RecordsStore);
app.factory('RestfulClient', ['$http', '$upload', AngularRecordStore.RestfulClient]);