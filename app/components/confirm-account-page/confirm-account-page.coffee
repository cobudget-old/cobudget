module.exports =
  url: '/confirm_account?confirmation_token&:group_id'
  template: require('./confirm-account-page.html')
  controller: ($scope, $auth, LoadBar, $location, $stateParams, Records, Toast) ->

    $scope.confirmationToken = $stateParams.confirmation_token
    $scope.groupId = $stateParams.group_id

    $scope.confirmAccount = (formData) ->
      LoadBar.start()
      params =
        name: formData.name
        password: formData.password
        confirmation_token: $scope.confirmationToken

      Records.users.confirmAccount(params)
        .then (data) ->
          user = data.users[0]
          global.cobudgetApp.currentUserId = user.id
          loginParams = { email: user.email, password: formData.password }
          $auth.submitLogin(loginParams)
            .then (ev, user) ->
              if $scope.groupId
                $location.search('confirmation_token', null)
                $location.search('group_id', null)
                $location.path("/groups/#{$scope.groupId}/setup")
        .catch ->
          Toast.show('Sorry, that confirmation token has expired.')
          $location.path('/')
