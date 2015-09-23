module.exports =
  url: '/confirm_account?confirmation_token'
  template: require('./confirm-account-page.html')
  controller: ($scope, $location, $stateParams, Records) ->

    $scope.userConfirmingAccount = false

    $scope.confirmationToken = $stateParams.confirmation_token

    $scope.confirmAccount = (formData) ->
      console.log('formData: ', formData)