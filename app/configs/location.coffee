### @ngInject ###

# enable html5 pushstate mode
global.cobudgetApp.config ($locationProvider) ->
  $locationProvider.html5Mode(true)
