`// @ngInject`
angular.module('cobudget').config (RestangularProvider, config) ->
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
  RestangularProvider.setDefaultHeaders
    Accept: "application/json"

  RestangularProvider.setResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is "get"
      console.log('get', what)
      return response.data[what]
    if operation is "getList"
      console.log('getList', what)
      return response.data[what]