module.exports =
  url: '/'
  template: require('./landing-page.html')
  controller: (Dialog, LoadBar, $location, Records, $scope, Session, ValidateAndRedirectLoggedInUser) ->

    ValidateAndRedirectLoggedInUser()

    $scope.startGroup = ->
      LoadBar.start()
      newUser = Records.users.build($scope.formData)
      newUser.save()
        .then (userData) ->
          Session.create(userData, redirectTo: 'group setup')
        .catch (err) ->
          LoadBar.stop()
          $location.path('/login').search({setup_group: true, email: newUser.email})
    return
