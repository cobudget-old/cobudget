### @ngInject ###

global.cobudgetApp.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'groups', require('app/components/groups-page/groups-page.coffee')
    .state 'welcome', require('app/components/welcome-page/welcome-page.coffee')