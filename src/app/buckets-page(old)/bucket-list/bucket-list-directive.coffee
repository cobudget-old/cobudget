
controller=null
`// @ngInject`
controller = ($rootScope, $scope, Budget) ->
  $rootScope.$watch 'currentBudget', (budget) ->
    return unless budget

    console.log("current budget id", budget.current_round_id)
    Budget.getCurrentRound(budget.current_round_id).then (round) ->
      #console.log("round proj", round.round_projects[0])
      buckets = []
      for proj in round.round_projects
        #console.log("proj", proj.project)
        buckets.push(proj.project)


    # Budget.getBudgetBuckets(budget.id).then (buckets) ->
    #   _.each buckets, (bucket) ->
    #     #console.log(bucket)
    #     bucket.amount_funded = bucket.amount_filled

    #     if bucket.amount_filled == 0 && !bucket.maximum_cents
    #       bucket.percentage_funded = 0
    #     else
    #       bucket.percentage_funded = bucket.percentage_filled

    #     if bucket.maximum_cents
    #       bucket.maximum_dollars = (bucket.maximum_cents/100).toFixed(2)
    #     else
    #       bucket.maximum_dollars = (bucket.amount_filled / 100)


        # get the width of the progress-bar element, multiply by the percentage filled!
#        bucket.amount_margin = 0

#        bucket.my_allocation_total = 100

      $scope.buckets = buckets


window.Cobudget.Directives.BucketList = ->
  {
    restrict: 'EA'
    templateUrl: '/app/buckets-page/bucket-list/bucket-list.html'
    controller: controller
  }
