module.exports =
  url: '/login'
  template: require('./login-page.html')
  controller: ($auth, Dialog, Error, LoadBar, $location, Records, $scope, Session, ValidateAndRedirectLoggedInUser, $window) ->

    ValidateAndRedirectLoggedInUser().then ->
      $scope.authorized = true

    $scope.formData = {}
    email = $location.search().email
    setupGroup = $location.search().setup_group

    if email
      $location.search('email', null)
      $scope.formData.email = email

    $scope.login = (formData) ->
      LoadBar.start()
      redirectTo = if setupGroup then 'group setup' else 'group'
      Session.create(formData, {redirectTo: redirectTo})

    $scope.visitForgotPasswordPage = ->
      $location.path('/forgot_password')

    $scope.openFeedbackForm = ->
      $window.location.href = 'https://docs.google.com/forms/d/1-_zDQzdMmq_WndQn2bPUEW2DZQSvjl7nIJ6YkvUcp0I/viewform?usp=send_form';

    return
