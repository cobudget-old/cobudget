null

### @ngInject ###
global.cobudgetApp.factory 'CurrentUser', (Records, ipCookie) ->
  ->
    Records.users.find(ipCookie('currentUserId'))