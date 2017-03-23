null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: (config, $scope, $location, Records, $window) ->

      Records.allocations.fetchByGroupId($scope.group.id).then ->
        $scope.allocationsLoaded = true
        $scope.allTransactions = $scope.group.allTransactions()
        $scope.initialOrder = '-createdAt'
        data = $scope.group.balanceOverTime()
        $scope.chartConfig = {
          chart: {
              zoomType: 'x'
          },
          title: {
              text: 'Transactions by Date'
          },
          xAxis: {
              type: 'datetime'
          },
          yAxis: {
              title: {
                  text: 'Allocations ('+$scope.group.currencySymbol+')'
              }
          },
          series: [{
              type: 'area',
              name: 'Balance ('+$scope.group.currencySymbol+')',
              data: data
          }]
        }

      return
