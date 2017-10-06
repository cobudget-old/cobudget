null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: (config, $scope, $http, $stateParams) ->

      groupId = parseInt($stateParams.groupId)

      $http.get(config.apiPrefix + "/groups/#{groupId}/analytics")
        .then (res) ->
          $scope.allTransactions = res.data.group_data
          $scope.transactionsLoaded = true

      # Records.allocations.fetchByGroupId($scope.group.id).then ->
      #   $scope.allocationsLoaded = true
      #   $scope.allTransactions = $scope.group.allTransactions()
      #   console.log $scope.allTransactions[930].contributions
      #   $scope.initialOrder = '-createdAt'
      #   $scope.transactionLimit = 10
      #   $scope.startingPage = 1
      #   data = $scope.group.balanceOverTime()
      #   $scope.chartConfig = {
      #     chart: {
      #         zoomType: 'x'
      #     },
      #     title: {
      #         text: null
      #     },
      #     xAxis: {
      #         type: 'datetime'
      #     },
      #     yAxis: {
      #         title: {
      #             text: 'Balance ('+$scope.group.currencySymbol+')'
      #         }
      #     },
      #     legend: {
      #       enabled: false
      #     },
      #     tooltip: {
      #       xDateFormat: '%e. %b %Y',
      #       shared: true
      #     },
      #     colors: ['#2BABE2'],
      #     series: [{
      #         type: 'area',
      #         name: 'Balance ('+$scope.group.currencySymbol+')',
      #         data: data
      #     }]
      #   }

      return
