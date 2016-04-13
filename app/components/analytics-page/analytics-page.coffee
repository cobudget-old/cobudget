module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/analytics'
  template: require('./analytics-page.html')
  controller: (config, CurrentUser, Error, $http, Records, $scope, UserCan) ->

    if UserCan.viewAnalyticsPage()
      $scope.authorized = true
      Error.clear()
      $http.get(config.apiPrefix + '/analytics/report')
        .then (res) ->
          $scope.data = res.data
          $scope.dataLoaded = true
    else
      $scope.authorized = false
      Error.set("you can't view this page")

    return
