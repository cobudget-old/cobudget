null

### @ngInject ###
global.cobudgetApp.factory 'CurrentUser', (Records, ipCookie) ->
  ->
    console.log("global.cobudgetApp.currentUserId: ", global.cobudgetApp.currentUserId)
    Records.users.find(global.cobudgetApp.currentUserId)