module.exports =
  url: '/forgot_password'
  template: require('./forgot-password-page.html')
  controller: (Dialog, $location, Records, $scope) ->

    $scope.formData = {}
    $scope.requestPassword = ->
      Records.users.requestPasswordReset($scope.formData)
        .then (res) ->
          Dialog.alert(title: 'Help is on the way!', content: 'Go check your email to reset your account.').then ->
            $location.path('/')
        .catch (err) ->
          Dialog.alert(title: 'Error', content: 'That email does not exist.')
