module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds'
  template: require('./manage-group-funds-page.html')
  controller: (config, CurrentUser, Error, LoadBar, Dialog, Records, $scope, $stateParams, $timeout, UserCan) ->

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

    $scope.csvData = ->
      groupMemberships = _.filter Records.memberships.collection.data, (membership) ->
        membership.groupId == groupId
      _.map groupMemberships, (membership) ->
        [membership.member().email, membership.rawBalance]

    $scope.csvFileName = ->
      timestamp = moment().format('YYYY-MM-DD-HH-mm-ss')
      "#{$scope.group.name}-member-data-#{timestamp}"

    $scope.openUploadCSVPrimerDialog = ->
      Dialog.custom
        template: require('./upload-csv-primer-dialog.tmpl.html')
        scope: $scope
        controller: ($scope, $mdDialog, $state) ->
          $scope.cancel = ->
            $mdDialog.cancel()

          $scope.uploadPath = ->
            "#{config.apiPrefix}/allocations/upload_review?group_id=#{groupId}"

          $scope.openCSVUploadDialog = ->
            $timeout( ->
              angular.element('.manage-group-funds-page__upload-csv-primer-dialog-hidden-btn input').trigger('click')
            , 100)

          $scope.onCSVUploadSuccess = (response) ->
            people = response.data.data
            $scope.cancel()
            $state.go('review-bulk-allocation', {people: people, groupId: groupId})

          $scope.onCSVUploadError = (response) ->
            $scope.cancel()
            Dialog.custom
              template: require('./upload-csv-error-dialog.tmpl.html')
              scope: $scope
              controller: ($scope, $mdDialog) ->
                $scope.csvUploadErrors = response.data.errors

                $scope.cancel = ->
                  $mdDialog.cancel()
                $scope.tryAgain = ->
                  $scope.openUploadCSVPrimerDialog()

    return
