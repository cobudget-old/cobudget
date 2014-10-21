`// @ngInject`
angular.module('cobudget').config (RestangularProvider, config) ->
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
  RestangularProvider.setDefaultHeaders
    Accept: "application/json"

  RestangularProvider.setResponseInterceptor (data, operation, what, url, response, deferred) ->
    return response.data[what]