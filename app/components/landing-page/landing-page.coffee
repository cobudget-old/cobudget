module.exports =
  url: '/'
  template: require('./landing-page.html')
  controller: ($auth, Dialog, $location, Records, $scope) ->

    $scope.startGroup = ->
      newUser = Records.users.build($scope.formData)
      newUser.save()
        .then (userData) ->
          $auth.submitLogin(userData).then ->
            $location.path('/setup_group')
        .catch (err) ->
          $location.path('/login').search(
            setup_group: true
            email: newUser.email
          )

    return
