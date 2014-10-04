`// @ngInject`
window.Cobudget.Config.Restangular = (RestangularProvider, config) ->
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
  RestangularProvider.setDefaultHeaders
    Accept: "application/json"

  
  RestangularProvider.setResponseInterceptor (data, operation, what, url, response, deferred) -> 
    if operation is "get"
      if what is "budgets"
        #console.log(response.data[0].budgets[0].current_round_id)
        return response.data[0].budgets
  