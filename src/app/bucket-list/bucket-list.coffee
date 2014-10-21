angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader, Round) ->

    $scope.groupId = $stateParams.groupId
    console.log('scope', $scope)
    RoundLoader.getCurrentRoundId($stateParams.groupId).then (round_id) ->
      RoundLoader.getBuckets(round_id).then (buckets) ->
        $scope.buckets = buckets
        
        ///Lots of this should be abstracted into a service///
        
        Round.get(round_id).then (round) ->
          $scope.round = round
          console.log('round', $scope.round.buckets)

          #Find total cents allocated
          total_cents_allocated = 0
          for bucket in $scope.round.buckets
            total_cents_allocated += bucket.allocation_total_cents

          #Find total cents allocatable
          total_cents_allocable = 0
          for allocator in $scope.round.allocators
            total_cents_allocable += allocator.allocation_rights_total_cents
            console.log(total_cents_allocable)

          #console.log('bucket', bucket.allocation_total_cents)
          #console.log(total_cents)  

          $scope.round.total_allocable = total_cents_allocable / 100
          $scope.round.total_allocated = total_cents_allocated / 100 
          $scope.round.time_left_days = 3
          $scope.round.time_left_hours = 72


