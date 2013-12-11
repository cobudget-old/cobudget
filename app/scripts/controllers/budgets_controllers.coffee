angular.module('controllers.budgets', [])
.controller('BudgetController',['$scope', '$rootScope', '$state', "Bucket", ($scope, $rootScope, $state, Bucket)->
  $scope.buckets = []
  #set up rules for slider
  $scope.allocatable = 4445

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

  $scope.allocations = []

  Bucket.query(budget_id: $state.params.budget_id, (response)->
    for b, i in response
      b.user_allocation = 0
      b.allocations = [{user_id: "asdf", amount: i+2*380}, {user_id: "fasfs", amount: i+5*100}, {user_id: "fa", amount: i+8*100}]
      setMinMax(b)
      $scope.buckets.push b
    console.log $scope.buckets
  )

  $scope.update_bucket = (bucket)->
    for bucket, i in $scope.buckets
      if bucket.id == $scope.buckets[i].id
        $scope.buckets[i] = bucket
        console.log $scope.buckets[i].allocations
        scope.$apply() unless $rootScope.$$phase
        return false

  $scope.$watch 'buckets', (n, o)->
    console.log n
    $scope.update_bucket(n)
  , true


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
