module.exports = (params) ->
  template: require('./remove-membership-dialog.html')
  scope: params.scope
  controller: (Dialog, $mdDialog, $scope, $window, $filter) ->
    membership = params.membership
    console.log membership
    $scope.member = membership.member()
    $scope.userHasFunds = membership.rawBalance != 0
    if !$scope.userHasFunds
      $scope.warnings = [
        "All of their funds will be removed from currently funding buckets",
        "All of their ideas will be cancelled",
        "All of their funding buckets will be cancelled and money will be refunded"
      ]
    else
      $scope.warnings = [
        $scope.member.name + " has " + $filter('currency')(membership.rawBalance, $scope.group.currencySymbol, 2)  + " in " + $scope.group.name,
        "You need to zero out " + $scope.member.name + "'s funds before removing from group"
      ]
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.proceed = ->
      $mdDialog.hide()
      membership.cancel().then ->
        Dialog.alert(
          title: 'Success!'
          content: "#{$scope.member.name} was removed from #{$scope.group.name}"
        ).then ->
          $window.location.reload()
