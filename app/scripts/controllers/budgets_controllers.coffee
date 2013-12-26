angular.module('controllers.budgets', [])
.controller('BudgetController',['$scope', '$rootScope', '$state', "Bucket", "Budget", ($scope, $rootScope, $state, Bucket, Budget)->
  $scope.buckets = []
  #set up rules for slider
  $scope.allocatable = $rootScope.current_user.allocatable

  setMinMax = (bucket)->
    if bucket.minimum_cents?
      bucket.minimum = parseFloat(bucket.minimum_cents) / 100
    else
      bucket.minimum = 0
    if bucket.maximum_cents?
      bucket.maximum = parseFloat(bucket.maximum_cents) / 100
    else
      bucket.maximum = 0
    bucket

  $scope.user_id = $rootScope.current_user.id
  $scope.user_allocations = []

  Budget.getBudgetBuckets(1).then((success)->
    for b, i in success
      b.user_allocation = 0
      b.allocations = [
        {bucket_id: b.id, user_id: 1, user_color: "#00499C", amount: i+2*380}, 
        {bucket_id: b.id, user_id: 2, user_color: "#407DC2", amount: i+5*100}, 
        {bucket_id: b.id, user_id: 3, user_color: "#639DE0", amount: i+8*100}]
      setMinMax(b)
      $scope.buckets.push b
  , (error)->
    console.log error
  )

  $scope.prepareUserAllocations = ->
    allocations = []
    sum = 0
    for bucket in $scope.buckets
      #eventually a prob when allocations to same bucket.
      for allocation, i in bucket.allocations
        if allocation.user_id == $scope.user_id
          allocation.label = "#{bucket.name} ($#{allocation.amount})"
          sum += allocation.amount
          if allocation.amount > 0
            allocations.push allocation

    unallocated = $scope.allocatable - sum 
    allocations.push {user_id: undefined, label: "unallocated ($#{unallocated})", amount: unallocated }
    $scope.user_allocations = allocations.reverse()

  $scope.prepareUserAllocations()

  $scope.chart_options = 
    segmentShowStroke : true
    segmentStrokeColor : "#fff"
    animation : false,

  $scope.prepareChart = ()->
    ch_vals = []
    angular.forEach($scope.user_allocations, (allocation)->
      ch_val = { value: allocation.amount, color:"#F7464A" }
      ch_vals.push ch_val
    )
    $scope.chart = ch_vals

  $scope.prepareChart()
    
  $scope.$watch 'user_allocations', (n, o)->
    if n != o
      $scope.prepareChart()

  $rootScope.channel.bind('bucket_created', (bucket) ->
    setMinMax(bucket.bucket)
    $scope.buckets.unshift bucket.bucket
    $scope.$apply()
  )

  $rootScope.channel.bind('bucket_updated', (bucket) ->
    for i in [0...$scope.buckets.length]
      bk = $scope.buckets[i]
      if bk.id == bucket.bucket.id
        $scope.buckets[i] = bucket.bucket
        setMinMax($scope.buckets[i])
    $scope.$apply()
  )
])
