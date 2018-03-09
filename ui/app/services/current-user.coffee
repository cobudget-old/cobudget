null

### @ngInject ###
global.cobudgetApp.factory 'CurrentUser', (Records) ->
  ->
    Records.users.find(global.cobudgetApp.currentUserId)