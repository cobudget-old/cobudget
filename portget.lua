socket = require "socket"
socket_unix = require "socket.unix"
http = require "socket.http"
ltn12 = require "ltn12"
cjson = require "cjson"
t = {}
r,c,h = http.request{
  host= "/var/run/docker.sock",
  path= "/containers/cobudget/json",
  scheme="http",
  sink=ltn12.sink.table(t),
  create=socket_unix,
}
value = cjson.decode(table.concat(t))
cobudget_port = value["NetworkSettings"]["Ports"]["3000/tcp"][1]["HostPort"]
mailcatcher_port = value["NetworkSettings"]["Ports"]["1080/tcp"][1]["HostPort"]
print("cobudget: " .. cobudget_port .. " mailcatcher: " .. mailcatcher_port)
