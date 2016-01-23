# http://i.imgur.com/RMs4njZ.gifv

module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/setup_group'
  template: require('./group-setup-page.html')
  controller: ($location, Records, $scope) ->

    $scope.createGroup = (formData) ->
      Records.groups.build(name: formData.name).save().then ->
        Records.memberships.fetchMyMemberships().then (data) ->
          newGroup = _.find data.groups, (group) ->
            group.name == formData.name
          $location.path("/groups/#{newGroup.id}")
