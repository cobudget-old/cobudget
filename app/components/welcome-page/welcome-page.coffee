module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope) ->
    
    console.log('[welcome-page] is loaded')

    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin
        email: formData.email
        password: formData.password

    $scope.$on 'auth:login-success', (event, user) ->
      global.cobudgetApp.currentUserId = user.id

      if global.cobudgetApp.initialRequestPath == undefined || global.cobudgetApp.initialRequestPath == '/'
        Records.memberships.fetchMyMemberships().then (data) ->
          if !global.cobudgetApp.currentGroupId
            global.cobudgetApp.currentGroupId = data.groups[0].id
          $location.path("/groups/#{global.cobudgetApp.currentGroupId}")
      else
        $location.path(global.cobudgetApp.initialRequestPath)

    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"

    return