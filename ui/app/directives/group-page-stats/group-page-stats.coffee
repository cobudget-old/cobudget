null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: (config, $scope, $http, $stateParams, $filter, Records) ->

      groupId = parseInt($stateParams.groupId)

      # transaciton table
      $scope.transactionQuery = ''
      $scope.transactionColumns = ['created_at', 'account_from', 'account_to', 'amount']
      $scope.transactionHeaders = ['Created At', 'Account From', 'Account To', 'Amount']

      $scope.$watch 'transactionQuery', ->
        $scope.filteredTransactions = $filter('filter')($scope.allTransactions, $scope.transactionQuery)

      $http.get(config.apiPrefix + "/groups/#{groupId}/analytics")
        .then (res) ->
          $scope.transactionsLoaded = true
          $scope.allTransactions = res.data.group_data
          $scope.filteredTransactions = $scope.allTransactions
          $scope.initialOrderTransactions = '-created_at'
          $scope.transactionLimit = 10
          $scope.startingPageTransactions = 1

      # bucket table
      $scope.bucketQuery = ''
      $scope.bucketHeaders = ['Link', 'Bucket Name', 'Author Name', 'Author Email', 'Total Contributions', 'Funded At', 'Completed At']
      $scope.bucketColumns = ['url', 'name', 'authorName', 'authorEmail', 'totalContributions', 'fundedAt', 'paidAt']

      $scope.$watch 'bucketQuery', ->
        $scope.filteredBuckets = $filter('filter')($scope.fundedBuckets, {name: $scope.bucketQuery})

      Records.buckets.fetchByGroupId(groupId).then (data) ->
        $scope.bucketsLoaded = true
        $scope.fundedBuckets = $scope.group.fundedBuckets()
        $scope.filteredBuckets = $scope.fundedBuckets
        $scope.fundedCompletedBuckets = $scope.group.fundedCompletedBuckets()
        _.each $scope.fundedCompletedBuckets, (bucket) ->
          bucket.url = location.origin + '/#/buckets/' + bucket.id
          bucket.authorEmail = bucket.author().email
        $scope.bucketLimit = 10
        $scope.startingPageBuckets = 1
        $scope.initialOrderBuckets = '-createdAt'

      return
