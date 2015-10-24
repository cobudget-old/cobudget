module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/setup_group'
  template: require('./group-setup-page.html')
  controller: (Error, LoadBar, $location, Records, $scope, UserCan) ->

    LoadBar.start()
    if UserCan.viewGroupSetupPage()
      $scope.authorized = true
      LoadBar.stop()
    else
      $scope.authorized = false
      LoadBar.stop()
      Error.set("you can't view this page")

    $scope.newGroup = Records.groups.build()
    $scope.saveGroup = ->
      $scope.newGroup.save().then (data) ->
        group = data.groups[0]
        $location.path('/')
