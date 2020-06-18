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
          $scope.groups = res.data.group_data
          $scope.dataLoaded = true
          $scope.initialOrder = '-created_at'
          inviteData = $scope.data.user_counts.cumulative_user_invite_count_data
          groupData = $scope.data.group_counts.cumulative_group_count_data
          newBucketData = $scope.data.bucket_counts.new_buckets_data
          fundedBucketData = $scope.data.bucket_counts.funded_buckets_data

          $scope.chartConfigInvites = {
            chart: {
                zoomType: 'x'
            },
            title: {
                text: null
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                title: {
                    text: 'User invites'
                }
            },
            legend: {
              enabled: false
            },
            tooltip: {
              shared: true
            },
            colors: ['#2BABE2'],
            series: [{
                type: 'area',
                name: 'Invites',
                data: inviteData
            }]
          }

          $scope.chartConfigGroups = {
            chart: {
                zoomType: 'x'
            },
            title: {
                text: null
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                title: {
                    text: 'Groups Created'
                }
            },
            legend: {
              enabled: false
            },
            tooltip: {
              shared: true
            },
            colors: ['#2BABE2'],
            series: [{
                type: 'area',
                name: 'Groups Created',
                data: groupData
            }]
          }

          $scope.chartConfigNewBuckets = {
            chart: {
                zoomType: 'x'
            },
            title: {
                text: null
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                title: {
                    text: 'Buckets Created'
                }
            },
            legend: {
              enabled: false
            },
            tooltip: {
              shared: true
            },
            colors: ['#2BABE2'],
            series: [{
                type: 'area',
                name: 'Buckets Created',
                data: newBucketData
            }]
          }

          $scope.chartConfigFundedBuckets = {
            chart: {
                zoomType: 'x'
            },
            title: {
                text: null
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                title: {
                    text: 'Buckets Funded'
                }
            },
            legend: {
              enabled: false
            },
            tooltip: {
              shared: true
            },
            colors: ['#2BABE2'],
            series: [{
                type: 'area',
                name: 'Buckets Funded',
                data: fundedBucketData
            }]
          }

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
