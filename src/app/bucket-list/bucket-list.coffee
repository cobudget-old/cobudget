angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader, Round, BudgetLoader, Contribution, AuthService, Restangular) ->

    ///Lots of this should be abstracted into a service///

    $scope.loadContributorDetails = () ->
      RoundLoader.getContributorDetails($scope.round.id, $scope.currentUser.id).then (details) ->
        $scope.myRoundDetails = details

    $scope.groupId = $stateParams.groupId
    RoundLoader.getLatestRoundId($stateParams.groupId).then (round_id) ->
      Round.get(round_id).then (round) ->
        $scope.round =  round
        $scope.loadContributorDetails()

        _.each $scope.round.buckets, (bucket, index) ->
          # get current user's contribution
          my_contribution_index = _.findIndex bucket.contributions, (contribution) ->
            contribution.user.id == AuthService.getCurrentUser().id

          # if a contribution from this user already exists
          if my_contribution_index != -1
            # get existing contribution
            bucket.my_contribution = bucket.contributions[my_contribution_index]
            # remove my_contribution from contributions and save as group_contribution
            bucket.group_contribution = _.clone(bucket.contributions)
            bucket.group_contribution.splice(my_contribution_index, 1)
            console.log(bucket.contributions, my_contribution_index, _.clone(bucket.contributions).splice(my_contribution_index, 1))
          else
            # create an empty contribution
            bucket.my_contribution = {
              user_id: AuthService.getCurrentUser().id
              bucket_id : bucket.id
              amount_cents: 0
            }
            # my_contribution index will be at end of existing contributions
            my_contribution_index = bucket.contributions.length
            # we don't have a contribution, so all contributions are group_contribution
            bucket.group_contribution = bucket.contributions

          # compute 'amount_dollars' derived property
          bucket.my_contribution.amount_dollars = bucket.my_contribution.amount_cents / 100.0

          bucket.my_contribution.bucket_id = bucket.id
          
          # compute 'contribution_total_cents'
          bucket.contribution_total_cents = _.reduce(_.pluck(bucket.group_contribution, "amount_cents"), ((sum, num) ->
            sum + num), 0)
          # compute 'percentage_funded'
          bucket.percentage_funded = (bucket.contribution_total_cents / bucket.target_cents) * 100

          
          
          $scope.$watch "round.buckets["+index+"].my_contribution.amount_dollars", (amount_dollars) ->
            my_contribution = $scope.round.buckets[index].my_contribution
            # re-compute 'amount_cents' from 'amount_dollars'
            my_contribution.amount_cents = my_contribution.amount_dollars * 100.0
            # compute my_contribution amount versus total percentage
            bucket.my_contribution_percentage = (my_contribution.amount_cents / bucket.target_cents) * 100
            # update current users' contribution within list of contributions
            bucket.contributions[my_contribution_index] = my_contribution
            console.log(bucket)
            

        $scope.saveContribution = (contribution) ->
          unsaved = _.clone(contribution)
          # remove 'amount_dollars' computed property
          delete unsaved.amount_dollars
          Contribution.save(unsaved).then (saved) ->
            if saved
              contribution.id = saved.id
            $scope.loadContributorDetails()

        #Find total cents contributed to round for bucket list sum
        total_cents_contributed = 0
        for bucket in $scope.round.buckets
          total_cents_contributed += bucket.contribution_total_cents

        #Find total round funds for bucket list sum
        round_funds_total_cents = 0
        for allocation in $scope.round.allocations
          round_funds_total_cents += allocation.amount_cents

        $scope.round.total_allocable = round_funds_total_cents / 100
        console.log('round funds total', round_funds_total_cents)
        $scope.round.total_allocated = total_cents_contributed / 100
        $scope.round.time_left_days = 3
        $scope.round.time_left_hours = 72

    BudgetLoader.setBudgetByRoute()

