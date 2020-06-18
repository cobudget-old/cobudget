module.exports = (params) ->
  template: require('./create-group-dialog.html')
  scope: params.scope
  controller: (Dialog, $mdDialog, $scope, $window, $location, LoadBar, Records, Session) ->

    $scope.startGroup = ->
      $location.hash('')
      LoadBar.start()
      newUser = Records.users.build($scope.formData)
      newUser.save()
        .then (userData) ->
          Session.create(userData, redirectTo: 'group setup')
        .catch (err) ->
          LoadBar.stop()
          $location.path('/login').search({setup_group: true, email: newUser.email})

    $scope.cancel = ->
      $mdDialog.cancel()
