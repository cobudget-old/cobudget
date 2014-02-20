angular.module('controllers.budgets', [])
.controller('BudgetController',['$scope', '$rootScope', '$state', '$filter', 'User', "Bucket", "Budget", "ColorGenerator", 'ConstrainedSliderCollector', ($scope, $rootScope, $state, $filter, User, Bucket, Budget, ColorGenerator, ConstrainedSliderCollector)->
  console.log "BUDGET CONTROLLER"
  if _.isEmpty(User.getCurrentUser())
    $state.go("home")
  console.log "Budget", User.getCurrentUser()

  $scope.state = $state.params.state
  $scope.budget_id = $state.params.budget_id
  $scope.budget = {}

  Budget.getBudget($state.params.budget_id).then (success)->
    $scope.budget = success
  , (error)->
    console.log error

  #not sure about these methods, should go in directive.
  $scope.refreshBucket = (bucket, position)->
    bucket.color = ColorGenerator.makeColor(0.3,0.3,0.3,0,position * 1.25,4,177,65, position)
    $scope.refreshBucketAllocations(bucket)

  $scope.refreshBucketAllocations = (bucket)->
    Bucket.getBucketAllocations(bucket.id).then (success)->
      if success.length > 0
        for na in success
          for oa, i in bucket.allocations
            #if the amount has changed update allocation
            if oa.user_id == na.user_id
              if oa.amount != na.amount
                bucket.allocations[i].amount = na.amount
                #if the changed allocation is from the user update the user_allocation
                if bucket.allocations[i].user_id == User.getCurrentUser().id
                  bucket.user_allocation = na.amount


  $rootScope.$on 'user_allocation_updated', (event, data)->
    console.log event, data

  $rootScope.channel.bind('bucket_created', (response) ->
    $scope.buckets.unshift response.bucket
    $scope.$apply()
  )

  $rootScope.channel.bind('bucket_updated', (response) ->
    for old_bucket, i in $scope.buckets
      if old_bucket.id == response.bucket.id
        response.bucket.allocations = $scope.buckets[i].allocations
        response.bucket.user_allocation = $scope.buckets[i].user_allocation
        $scope.buckets[i] = response.bucket
        $scope.refreshBucket($scope.buckets[i], i)
        break
    $scope.$apply()
  )
])
