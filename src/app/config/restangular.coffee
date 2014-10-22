`// @ngInject`
angular.module('cobudget').config (RestangularProvider, config) ->
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
  RestangularProvider.setDefaultHeaders
    Accept: "application/json"

  RestangularProvider.setResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is "get"
      # Trim the 's' off so we can reference the singular root note name
      # This is a total hack and won't work for resources like "people"
      return response.data[what.substring(0, what.length-1)]
    if operation is "getList"
      return response.data[what]

