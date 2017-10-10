null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: (config, $scope, $http, $stateParams, $filter) ->

      groupId = parseInt($stateParams.groupId)
      $scope.query = ''

      $scope.$watch 'query', ->
        $scope.filteredTransactions = $filter('filter')($scope.allTransactions, $scope.query)

      $http.get(config.apiPrefix + "/groups/#{groupId}/analytics")
        .then (res) ->
          $scope.transactionsLoaded = true
          $scope.allTransactions = res.data.group_data
          $scope.filteredTransactions = $scope.allTransactions
          $scope.initialOrder = '-createdAt'
          $scope.transactionLimit = 10
          $scope.startingPage = 1


      return
