module.exports = (params) ->
    template: require('./backers-list-dialog.html')
    scope: params.scope
    controller: (Dialog, $mdDialog, $scope) ->

      $scope.backers = params.backers

      $scope.ok = ->
        $mdDialog.cancel()
