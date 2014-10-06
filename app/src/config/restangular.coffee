`// @ngInject`
window.Cobudget.Config.Restangular = (RestangularProvider, config) ->
  RestangularProvider.setBaseUrl(config.apiEndpoint)
  RestangularProvider.setDefaultHttpFields
    withCredentials: true
  RestangularProvider.setDefaultHeaders
    Accept: "application/json"

  
  RestangularProvider.setResponseInterceptor (data, operation, what, url, response, deferred) -> 
    console.log("what", what)
    if operation is "get"
      if what is "budgets"
        #console.log(response.data[0].budgets[0].current_round_id)
        return response.data[0].budgets
      if what is "round"
        #console.log("round after interceptor", response.data.round)
        return response.data.round
