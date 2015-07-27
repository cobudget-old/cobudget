var port = process.env.PORT || 9000;
require('babel/register')
require('./app/server')().listen(port)
