module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds'
  template: require('./manage-group-funds-page.html')
  controller: (config, CurrentUser, Dialog, DownloadCSV, Error, LoadBar, Records, $scope, $stateParams, UserCan) ->

    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        LoadBar.stop()
        if UserCan.manageFundsForGroup(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
          $scope.currentUser = CurrentUser()
          Records.memberships.fetchByGroupId(groupId)
        else
          $scope.authorized = false
          Error.set("you can't view this page")
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    $scope.usingSafari = browser.safari

    $scope.downloadCSV = ->
      timestamp = moment().format('YYYY-MM-DD-HH-mm-ss')
      filename = "#{$scope.group.name}-member-data-#{timestamp}"
      params =
        url: "#{config.apiPrefix}/memberships.csv?group_id=#{groupId}"
        filename: filename
      DownloadCSV(params)

    $scope.openUploadCSVPrimerDialog = ->
      uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
        scope: $scope
      })
      Dialog.open(uploadCSVPrimerDialog)

    return
