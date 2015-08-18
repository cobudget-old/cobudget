### @ngInject ###

global.cobudgetApp.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'group', require('app/components/group-page/group-page.coffee')
    .state 'welcome', require('app/components/welcome-page/welcome-page.coffee')
    .state 'create-project', require('app/components/create-project-page/create-project-page.coffee')
    .state 'project', require('app/components/project-page/project-page.coffee')