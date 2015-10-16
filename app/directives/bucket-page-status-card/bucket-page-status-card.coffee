null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageStatusCard', () ->
    restrict: 'E'
    template: require('./bucket-page-status-card.html')
    replace: true
    controller: ($scope, Toast) ->

      $scope.userCanStartFunding = ->
        $scope.membership.isAdmin ||  $scope.bucket.author().id == $scope.membership.member().id

      $scope.openForFunding = ->
        if $scope.bucket.target
          $scope.bucket.openForFunding().then ->
            $scope.back()
            Toast.showWithRedirect('You launched a bucket for funding', "/buckets/#{$scope.bucket.id}")
        else
          alert('Estimated funding target must be specified before funding starts')        
