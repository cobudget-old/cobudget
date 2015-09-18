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
      console.log('[welcome-page] login was successful!')
      global.cobudgetApp.currentUserId = user.id
      console.log('[welcome-page] global.cobudgetApp.currentUserId set to: ', global.cobudgetApp.currentUserId)

      if global.cobudgetApp.initialRequestPath == undefined || global.cobudgetApp.initialRequestPath == '/'
        console.log('[welcome-page] initialRequestPath either not set or set to "/"')
        Records.memberships.fetchMyMemberships().then (data) ->
          console.log('[welcome-page] memberships fetched!')
          if !global.cobudgetApp.currentGroupId
            console.log('[welcome-page] global.cobudgetApp.currentGroupId not set')
            global.cobudgetApp.currentGroupId = data.groups[0].id
            console.log('[welcome-page] global.cobudgetApp.currentGroupId set to: ', global.cobudgetApp.currentGroupId)
          console.log('[welcome-page] redirecting to: ', "/groups/#{global.cobudgetApp.currentGroupId}")
          $location.path("/groups/#{global.cobudgetApp.currentGroupId}")
      else
        console.log('[welcome-page] global.cobudgetApp.initialRequestPath was set!')
        console.log('[welcome-page] redirecting to: ', global.cobudgetApp.initialRequestPath)

        $location.path(global.cobudgetApp.initialRequestPath)
        
    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"

    return