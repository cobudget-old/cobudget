module.exports = (params) ->
  template: require('./remove-membership-dialog.html')
  scope: params.scope
  controller: (Dialog, $mdDialog, $scope, $window) ->
    membership = params.membership
    $scope.member = membership.member()
    $scope.warnings = [
      "All of their funds will be removed from currently funding buckets",
      "All of their funds will be removed from the group",
      "All of their ideas will be archived",
      "All of their funding buckets will be archived and money will be refunded"
    ]
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.proceed = ->
      $mdDialog.hide()
      membership.archive().then ->
        Dialog.alert(
          title: 'Success!'
          content: "#{$scope.member.name} was removed from #{$scope.group.name}"
        ).then ->
          $window.location.reload()
