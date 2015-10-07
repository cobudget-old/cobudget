### @ngInject ###

global.cobudgetApp.config ($authProvider, config) ->
  $authProvider.configure
    apiUrl: config.apiPrefix
    validateOnPageLoad: true