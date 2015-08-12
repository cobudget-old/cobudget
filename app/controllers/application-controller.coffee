### @ngInject ###

global.cobudgetApp.controller 'ApplicationController', (Records) ->
  Records.memberships.fetchMyMemberships()