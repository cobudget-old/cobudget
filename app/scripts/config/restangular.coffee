window.Cobudget.Config.Restangular = (RestangularProvider, config) ->
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
