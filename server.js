var port = process.env.PORT || 9000;
require('coffee-script/register')
require('./src/server')().listen(port)
