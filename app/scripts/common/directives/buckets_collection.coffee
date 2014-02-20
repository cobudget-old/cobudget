angular.module("directives.buckets_collection", [])
.directive "bucketsCollection", ['$q', '$rootScope', '$state', '$timeout', 'Budget', 'User', 'Allocation', 'Bucket', 'ColorGenerator', ($q, $rootScope, $state, $timeout, Budget, User, Allocation, Bucket, ColorGenerator) ->
  restrict: "EA"
  transclude: "false"
  templateUrl: "/views/directives/buckets.collection.html"
  scope:
    budget_id: "@budgetId"
    account_balance: "@accountBalance"

  link: (scope, element, attrs) ->
    console.log "BUCKETS COlLECTION", scope, $state.params

    #utils
    getBucketUserAllocation = (bucket)->
      for a in bucket.allocations
        if a.user_id == User.getCurrentUser().id
          return a.amount

    #load the buckets methods
    loadBucketsWithoutAllocations = ->
      Budget.getBudgetBuckets(scope.budget_id, $state.params.state).then (buckets)->
        return buckets
      , (error)->
        console.log error

    loadBucketsAllocations = (buckets)->
      deferred = $q.defer()
      promises = []
      angular.forEach buckets, (bucket)->
        promises.push Bucket.getBucketAllocations(bucket.id)
      #this respects the order we passed in so we are safe to foreach the buckets again
      $q.all(promises).then (allocations_array)->
        buckets_with_allocations = []
        for allocations, i in allocations_array
          buckets[i].color = ColorGenerator.makeColor(0.3,0.3,0.3,0,i * 1.25,4,177,65, i)
          buckets[i].allocations = allocations
          buckets[i].user_allocation = getBucketUserAllocation(buckets[i])
          buckets_with_allocations.push buckets[i]
          if i == buckets.length - 1
            scope.buckets = buckets_with_allocations
            return buckets_with_allocations

    setUserAllocations = (buckets_with_allocations)->
      user_allocations = []
      angular.forEach buckets_with_allocations, (bucket)->
        angular.forEach bucket.allocations, (allocation)->
          if allocation.user_id == User.getCurrentUser().id
            if allocation.amount > 0
              allocation.label = "#{bucket.name}"
              allocation.bucket_color = bucket.color
              user_allocations.push allocation
      scope.user_allocations = user_allocations
      return user_allocations

    addUnallocatedToUserAllocations = ()->
      scope.user_allocations.push {user_id: undefined, label: "Unallocated", amount: scope.unallocated, bucket_color: "#ececec" }
      scope.user_allocations

    setCollectionAllocationGlobals = (user_allocations)->
      User.getAccountForBudget($state.params.budget_id)[0].then (account)->
        scope.account_balance = account.allocation_rights_cents
        scope.allocated = Budget.getUserAllocated(user_allocations)
        scope.allocatable = Budget.getUserAllocatable(scope.account_balance, scope.allocated)
        scope.unallocated = scope.allocatable - scope.allocated 
        addUnallocatedToUserAllocations()
        console.log scope.user_allocations
        return account
      , (error)->
        console.log error

    #load
    loadBucketsWithoutAllocations()
    .then(loadBucketsAllocations)
    .then(setUserAllocations) #takes bucktes
    .then(setCollectionAllocationGlobals) #takes user allocations
    .then ()->
      scope.buckets ||= []
      $rootScope.$broadcast("user-allocations-updated", {user_allocations: scope.user_allocations, buckets: scope.buckets})
      #force horiz graph to load
      $timeout ()->
        angular.forEach scope.buckets, (bucket)->
          $rootScope.$broadcast("bucket-allocations-updated", { bucket_allocations:bucket.allocations, bucket_id: bucket.id })

    #scope mehods
    scope.getTotalBucketAllocations = (bucket)->
      Bucket.sumBucketAllocations(bucket)
      
    #events
    scope.$on 'current-user-bucket-allocation-update', (event, data)->
      #This is probably computationally expensive and could be done better with passing 
      #bucket id and allocation amount in and updating vals from there, but for now...
      #SOMETHING WRONG HERE IT'S adding to shit
      user_allocations = setUserAllocations(scope.buckets)
      setCollectionAllocationGlobals(user_allocations).then ()->
        $rootScope.$broadcast("user-allocations-updated",{user_allocations: user_allocations, buckets: scope.buckets })
        for bucket in scope.buckets
          if bucket.id == data.bucket_id
            $rootScope.$broadcast("bucket-allocations-updated", { bucket_allocations: bucket.allocations, bucket_id: bucket.id })
            break

    scope.$on 'admin-mode-toggle', (evt, data)->
      scope.admin = data

    #pushers
    $rootScope.channel.bind('allocation_updated', (response) ->
      if scope.buckets?
        response.amount = parseFloat(response.amount)
        for bucket, idx in scope.buckets
          #ignore for self
          if response.user_id == User.getCurrentUser().id
            break
          #get the bucket
          if response.bucket_id == bucket.id
            for allocation, i in bucket.allocations
              #match to user
              if allocation.user_id == response.user_id
                scope.buckets[idx].allocations[i].amount += response.amount * 100
          #maybe use this for user and others.
                $rootScope.$broadcast("bucket-allocations-updated", { bucket_allocations:scope.buckets[idx].allocations, bucket_id: scope.buckets[idx].id })
        scope.$apply()
    )

]
