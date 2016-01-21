# (EL) NOTE: may want to use this as an 'edit group' page in the future
# http://i.imgur.com/RMs4njZ.gifv

module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/setup_group'
  template: require('./group-setup-page.html')
  controller: ($location, $scope) ->

    $scope.createGroup = (formData) ->
      $scope.group.name = formData.name
      $scope.group.save().then ->
        $location.path("/groups/#{$scope.group.id}")
