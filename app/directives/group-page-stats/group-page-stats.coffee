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
          $scope.transactionsLoaded = true
          $scope.allTransactions = res.data.group_data
          $scope.initialOrder = '-createdAt'
          $scope.transactionLimit = 10
          $scope.startingPage = 1
    
      return
