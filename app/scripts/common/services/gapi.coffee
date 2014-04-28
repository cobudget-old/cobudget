angular.module("services.gapi", [])
.service "GAPI", [ "$http", "$rootScope", "$q", "config", ($http, $rootScope, $q, config)->
  clientId = config.googClient
  apiKey = config.googApiKey
  scopes = "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email"
  #domain = "localhost:9000"
  deferred = $q.defer()
  deferred1 = $q.defer()
  handleAuthResult = (authResult)->
    if authResult and not authResult.error
      data = {}
      gapi.client.load "oauth2", "v2", ->
        request = gapi.client.oauth2.userinfo.get()
        request.execute (resp) ->
          data.email = resp.email
          data.name = resp.name
          deferred.resolve data
    else
      deferred.reject "error"

  handleAuthResult1 = (authResult)->
    if authResult? and not authResult.error
      data = {}
      gapi.client.load "oauth2", "v2", ->
        request = gapi.client.oauth2.userinfo.get()
        request.execute (resp) ->
          data.email = resp.email
          data.name = resp.name
          deferred1.resolve data
    else
      deferred1.reject "error"

  checkAuth: ->
    gapi.auth.authorize
      client_id: clientId
      scope: scopes
      immediate: true
      #hd: domain
    , handleAuthResult
    deferred.promise

  login: ->
    gapi.auth.authorize
      client_id: clientId
      scope: scopes
      immediate: false
      #hd: domain
    , handleAuthResult1
    deferred1.promise

  handleClientLoad: ->
    gapi.client.setApiKey apiKey
    window.setTimeout gapi.auth.init( -> ), 1
    window.setTimeout @checkAuth(), 2
]
