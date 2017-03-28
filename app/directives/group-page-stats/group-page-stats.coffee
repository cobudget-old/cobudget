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
        $scope.transactionLimit = 10
        $scope.startingPage = 1
        data = $scope.group.balanceOverTime()
        $scope.chartConfig = {
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
                  text: 'Balance ('+$scope.group.currencySymbol+')'
              }
          },
          legend: {
            enabled: false
          },
          tooltip: {
            xDateFormat: '%e. %b %Y',
            shared: true
          },
          colors: ['#1EA9E3'],
          series: [{
              type: 'area',
              name: 'Balance ('+$scope.group.currencySymbol+')',
              data: data
          }]
        }

      return
