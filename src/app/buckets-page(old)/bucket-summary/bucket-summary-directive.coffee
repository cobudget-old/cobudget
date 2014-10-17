controller=null
`// @ngInject`
controller = ($rootScope, $scope, Organization) ->
  $rootScope.$watch 'currentBudget', (budget) ->
    return unless budget
    # new Date(year, month, day, hours, minutes, seconds, milliseconds);
    start_time = new Date(2014, 8, 1, 9, 0, 0, 0)
    end_time = new Date(2014, 8, 5, 9, 0, 0, 0)
    current_time = new Date()

    total_time_for_budget = end_time.getTime() -  start_time.getTime()
    total_time_left = end_time.getTime() - current_time.getTime()

    $scope.total_hours = Math.ceil(total_time_for_budget / (1000 * 3600))
    $scope.total_hours = 0 if $scope.total_hours < 0


    $scope.hours_left = Math.ceil(total_time_left / (1000 * 3600))
    $scope.hours_left = 0 if $scope.hours_left < 0

    if $scope.hours_left == 0
      $scope.budget_time_message = "This round is finished! Thanks everyone!"
    else if $scope.hours_left < 24
      $scope.budget_time_message = "There are #{$scope.hours_left} hours left in the round!"
    else
      days_left = $scope.hours_left / 24
      $scope.budget_time_message = "There are #{Math.floor(days_left)} days left in the round!"

    percent_complete = (1 - ($scope.hours_left / $scope.total_hours)) * 100

    percent_complete = 0 if current_time < start_time
    percent_complete = 100 if current_time > end_time


    $scope.percent_complete_style = "width: #{percent_complete}%"

    if $scope.hours_left > 0
      $scope.budget_close_message = "Round closes at 9am, 5 September 2014"
    else
      $scope.budget_close_message = "Round closed at 9am, 5 September 2014"

window.Cobudget.Directives.BucketSummary = ->
  {
    restrict: 'EA'
    templateUrl: '/app/buckets-page/bucket-summary/bucket-summary.html'
    controller: controller
  }
