module.exports =
  url: '/forgot_password'
  template: require('./forgot-password-page.html')
  controller: ($auth, Dialog, $location, Records, $scope) ->
    console.log('i loaded')

    $scope.formData = {}
    $scope.requestPassword = ->
      console.log('i have been called')
      # Records.users.resetPassword($scope.formData)
      $auth.requestPasswordReset($scope.formData)
        .then (res) ->
          console.log('res: ', res)
          # Dialog.alert(title: 'Help is on the way!', content: 'Go check your email to reset your account.').then ->
          #   $location.path('/')
        .catch (err) ->
          console.log('err: ', err)
          # Dialog.alert(title: 'Error', content: 'That email does not exist.')

