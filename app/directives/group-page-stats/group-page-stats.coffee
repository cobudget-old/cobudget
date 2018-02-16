null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: (config, $scope, $http, $stateParams, $filter, DownloadCSV, Records) ->

      groupId = parseInt($stateParams.groupId)
      $scope.transactionQuery = ''
      $scope.bucketQuery = ''
      Records.buckets.fetchByGroupId(groupId).then (data) ->
        $scope.bucketsLoaded = true
        $scope.allBuckets = data.buckets
        $scope.filteredBuckets = $scope.allBuckets
        console.log $scope.filteredBuckets
        $scope.bucketLimit = 10
        $scope.startingPageBuckets = 1
        $scope.initialOrderBuckets = '-created_at'



      $scope.$watch 'transactionQuery', ->
        $scope.filteredTransactions = $filter('filter')($scope.allTransactions, $scope.transactionQuery)

      $scope.$watch 'bucketQuery', ->
        $scope.filteredBuckets = $filter('filter')($scope.allBuckets, $scope.bucketQuery)

      $http.get(config.apiPrefix + "/groups/#{groupId}/analytics")
        .then (res) ->
          $scope.transactionsLoaded = true
          $scope.allTransactions = res.data.group_data
          $scope.filteredTransactions = $scope.allTransactions
          console.log $scope.filteredTransactions
          $scope.initialOrderTransactions = '-created_at'
          $scope.transactionLimit = 10
          $scope.startingPageTransactions = 1

      $scope.downloadBucketsCSV = ->
        timestamp = moment().format('YYYY-MM-DD-HH-mm-ss')
        filename = "#{$scope.group.name}-bucket-data-#{timestamp}"
        params =
          url: "#{config.apiPrefix}/buckets.csv?group_id=#{$scope.group.id}"
          filename: filename
        DownloadCSV(params)


      return
