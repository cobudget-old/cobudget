module.exports =
  onEnter: (ValidateAndRedirectLoggedInUser) ->
    ValidateAndRedirectLoggedInUser()
  url: '/login'
  template: require('./login-page.html')
  controller: ($auth, Dialog, Error, LoadBar, $location, Records, $scope, $window) ->

    $scope.formData = {}
    email = $location.search().email
    if email
      $location.url($location.path())
      $scope.formData.email = email

    $scope.login = (formData) ->
      LoadBar.start()
      $auth.submitLogin(formData)
        .catch ->
          LoadBar.stop()

    $scope.visitForgotPasswordPage = ->
      $location.path('/forgot_password')

    $scope.openFeedbackForm = ->
      $window.location.href = 'https://docs.google.com/forms/d/1-_zDQzdMmq_WndQn2bPUEW2DZQSvjl7nIJ6YkvUcp0I/viewform?usp=send_form';

    return
