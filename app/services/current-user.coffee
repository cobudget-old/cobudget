null

### @ngInject ###
global.cobudgetApp.factory 'CurrentUser', (Records, AppConfig, ipCookie) ->

  setId: (id) ->
    ipCookie('currentUserId', id)

  get: ->
    id = ipCookie('currentUserId')
    Records.users.find(id)