module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
  url: '/analytics'
  template: require('./analytics-page.html')
  controller: (CurrentUser, Error, Records, $scope, UserCan) ->

    if UserCan.viewAnalyticsPage()
      $scope.authorized = true
      Error.clear()
    else
      $scope.authorized = false
      Error.set("you can't view this page")

    $scope.labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July']
    $scope.data = [ [28, 48, 40, 19, 86, 27, 90] ]
    $scope.series = ['user count']

    return
