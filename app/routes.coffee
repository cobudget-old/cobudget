### @ngInject ###

global.cobudgetApp.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/groups'
  $stateProvider
    .state 'groups', require('app/components/groups-page/groups-page.coffee')