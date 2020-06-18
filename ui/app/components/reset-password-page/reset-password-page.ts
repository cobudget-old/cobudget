module.exports =
  url: '/reset_password?reset_password_token'
  template: require('./reset-password-page.html')
  reloadOnSearch: false
  controller: (Dialog, LoadBar, $location, Records, $scope, Session, $stateParams, Toast) ->

    $scope.formData = {}
    resetPasswordToken = $stateParams.reset_password_token

    $scope.resetPassword = ->
      LoadBar.start()
      password = $scope.formData.password
      confirmPassword = $scope.formData.confirmPassword
      $scope.formData = {}
      if password == confirmPassword
        $location.search('reset_password_token', null)
        requestParams =
          password: password
          confirm_password: confirmPassword
          reset_password_token: resetPasswordToken
        Records.users.resetPassword(requestParams)
          .then (res) ->
            loginParams = {email: res.users[0].email, password: password}
            Session.create(loginParams, redirectTo: 'group')
          .catch (err) ->
            Toast.show('Your reset password token has expired, please request another')
            $location.path('/forgot_password')
            LoadBar.stop()
      else
        LoadBar.stop()
        Dialog.alert(title: 'Error!', content: 'Passwords must match.')
