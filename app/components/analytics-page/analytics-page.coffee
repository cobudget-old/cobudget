module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/analytics'
  template: require('./analytics-page.html')
  controller: (config, CurrentUser, Error, $http, Records, $scope, UserCan, DownloadCSV) ->

    if UserCan.viewAnalyticsPage()
      $scope.authorized = true
      $scope.reverse = true
      $scope.propertyName = 'confirmed_member_count'
      Error.clear()
      $http.get(config.apiPrefix + '/analytics/report')
        .then (res) ->
          $scope.data = res.data
          $scope.dataLoaded = true

      $scope.sortBy = (propertyName) ->
        $scope.reverse = if $scope.propertyName == propertyName then !$scope.reverse else false
        $scope.propertyName = propertyName

      $scope.adminCSV = ->
        timestamp = moment().format('YYYY-MM-DD-HH-mm-ss')
        filename = "admin-contact-info-#{timestamp}"
        params =
          url: "#{config.apiPrefix}/analytics/admins.csv"
          filename: filename
        DownloadCSV(params)

    else
      $scope.authorized = false
      Error.set("you can't view this page")

    return
