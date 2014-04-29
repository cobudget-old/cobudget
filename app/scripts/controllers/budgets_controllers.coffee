angular.module('controllers.budgets', [])
.controller('BudgetController',['$scope', '$rootScope', '$state', '$filter', 'User', "Bucket", "Budget", "ColorGenerator", 'ConstrainedSliderCollector', ($scope, $rootScope, $state, $filter, User, Bucket, Budget, ColorGenerator, ConstrainedSliderCollector)->
  if _.isEmpty(User.getCurrentUser())
    $state.go("home")

  $scope.state = $state.params.state
  $scope.getState = ->
    $state.params.state
  $scope.budget_id = $state.params.budget_id
  $scope.budget = {}


  Budget.getBudget($state.params.budget_id).then (success)->
    $scope.budget = success
  , (error)->
    console.log error

  ##not sure about these methods, should go in directive.

  #$scope.refreshBucketAllocations = (bucket)->
    #Bucket.getBucketAllocations(bucket.id).then (success)->
      #if success.length > 0
        #for na in success
          #for oa, i in bucket.allocations
            ##if the amount has changed update allocation
            #if oa.user_id == na.user_id
              #if oa.amount != na.amount
                #bucket.allocations[i].amount = na.amount
                ##if the changed allocation is from the user update the user_allocation
                #if bucket.allocations[i].user_id == User.getCurrentUser().id
                  #bucket.user_allocation = na.amount


  #$rootScope.$on 'user_allocation_updated', (event, data)->
    #console.log event, data
])
