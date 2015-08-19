null

### @ngInject ###
global.cobudgetApp.factory 'CurrentUser', (Records, ipCookie) ->

  setId: (id) ->
    ipCookie('currentUserId', id)

  get: ->
    id = ipCookie('currentUserId')
    Records.users.find(id)