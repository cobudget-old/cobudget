module.exports =
  url: '/reset_password?reset_password_token'
  template: require('./reset-password-page.html')
  controller: ($auth, Dialog, $location, Records, $scope, $stateParams) ->
    console.log('i loaded')

    $scope.formData = 
      reset_password_token: $stateParams.reset_password_token

    $scope.resetPassword = ->
      console.log('$scope.formData: ', $scope.formData)
      if $scope.formData.password == $scope.formData.confirm_password
        $location.search('reset_password_token', null)

        $auth.updatePassword($scope.formData)
          .then (res) ->
            console.log('res: ', res)
            # validate user and redirect to welcome page with toast
          .catch (err) ->
            console.log('err: ', err)
            # clear form
            # toast token expired

        # $auth.requestPasswordReset($scope.formData)
        #   .then (res) ->
        #     console.log('res: ', res)
        #   .catch (err) ->
        #     console.log('err: ', err)
      else
        Dialog.alert(title: 'Error!', content: 'Passwords must match.')

        

