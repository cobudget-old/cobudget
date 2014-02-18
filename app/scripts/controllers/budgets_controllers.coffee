angular.module('controllers.budgets', [])
.controller('BudgetController',['$scope', '$rootScope', '$state', '$filter', 'User', "Bucket", "Budget", "ColorGenerator", 'ConstrainedSliderCollector', ($scope, $rootScope, $state, $filter, User, Bucket, Budget, ColorGenerator, ConstrainedSliderCollector)->
  if _.isEmpty(User.getCurrentUser())
    $state.go("home")
  console.log "Budget", User.getCurrentUser(), User.getCurrentUser()
  $scope.budget = {}
  $scope.buckets = []
  $scope.buckets_holder = []
  $scope.user_allocations = []
  $scope.loaded_buckets = 0
  $scope.allocatable_holder = 0

  Budget.getBudget($state.params.budget_id).then (success)->
    $scope.budget = success
  , (error)->
    console.log error


  $scope.setMinMax = (bucket)->
    if bucket.minimum_cents?
      bucket.minimum = parseFloat(bucket.minimum_cents) / 100
    else
      bucket.minimum = 0
    if bucket.maximum_cents?
      bucket.maximum = parseFloat(bucket.maximum_cents) / 100
    else
      bucket.maximum = 0
    bucket

  loadBucketFrames = ->
    buckets = Budget.getBudgetBuckets($state.params.budget_id).then (success)->
        for b, i in success
          b.user_allocation = 0
          b.color = ColorGenerator.makeColor(0.3,0.3,0.3,0,i * 1.25,4,177,65, i)
          b.allocations = []
          $scope.setMinMax(b)
          $scope.loadBucketAllocations(b)
      , (error)->
        console.log error
    buckets

  loadAllocatable = ->
    if User.getCurrentUser().accounts.length == 0
      console.log "No Accounts"
      $scope.allocatable = 0
      User.getCurrentUser().allocatable = 0
      return false
    for acc in User.getCurrentUser().accounts
      if acc.budget_id == parseFloat($state.params.budget_id)
        if acc.allocation_rights_cents?
          $scope.allocatable = acc.allocation_rights_cents

  $scope.loadBucketAllocations = (bucket)->
    b = bucket
    Bucket.getBucketAllocations(b.id).then (success)->
      sum = 0
      if success.length > 0
        for a in success
          b.allocations.push a
          if a.user_id == User.getCurrentUser().id
            b.user_allocation = a.amount
      b.user_allocation
        #b.allocations = success
    .then (amount)->
      $scope.buckets_holder.push b
      $scope.allocatable_holder += parseInt(amount, 10)
      $scope.loaded_buckets++
      if $scope.loaded_buckets == $scope.loading_counter
        $scope.allocatable += $scope.allocatable_holder
        ordered = $filter('orderBy')($scope.buckets_holder, 'id')
        $scope.buckets = ordered

  loadAllocatable()
  loadBucketFrames().then((success)->
    $scope.loading_counter = success.length
  )

  $scope.refreshBucket = (bucket, position)->
    bucket.color = ColorGenerator.makeColor(0.3,0.3,0.3,0,position * 1.25,4,177,65, position)
    $scope.setMinMax(bucket)
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

  $scope.prepareUserAllocations = ()->
    allocations = []
    $scope.sum_of_user_allocations = 0
    sum = 0
    for bucket in $scope.buckets
      for allocation, i in bucket.allocations
        if allocation.user_id == User.getCurrentUser().id
          sum += allocation.amount
          allocation.label = "#{bucket.name}"
          allocation.bucket_color = bucket.color
          if allocation.amount > 0
            allocations.push allocation

    $scope.sum_of_user_allocations = sum
    unallocated = $scope.allocatable - sum 
    allocations.push {user_id: undefined, label: "Unallocated", amount: unallocated, bucket_color: "#ececec" }
    $scope.user_allocations = allocations.reverse()

  $scope.chart_options = 
    segmentShowStroke : true
    segmentStrokeColor : "#fff"
    animation : false,

  $scope.prepareChart = ()->
    ch_vals = []
    angular.forEach($scope.user_allocations, (allocation)->
      ch_val = { value: allocation.amount, color: allocation.bucket_color }
      ch_vals.push ch_val
    )
    $scope.chart = ch_vals

  $scope.$watch 'user_allocations', (n, o)->
    if n != o
      $scope.prepareChart()

  $rootScope.channel.bind('bucket_created', (response) ->
    Bucket.setMinMax(response.bucket)
    $scope.buckets.unshift response.bucket
    $scope.$apply()
  )

  $rootScope.channel.bind('allocation_updated', (response) ->
    response.amount = parseFloat(response.amount)
    for bucket, idx in $scope.buckets
      #ignore for self
      if response.user_id == User.getCurrentUser().id
        break
      #get the bucket
      if response.bucket_id == bucket.id
        for allocation, i in bucket.allocations
          #match to user
          if allocation.user_id == response.user_id
            $scope.buckets[idx].allocations[i].amount += response.amount * 100

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
