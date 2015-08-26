module.exports = 
  resolve: 
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/projects/:projectId'
  template: require('./project-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, Toast) ->
    
    groupId = global.cobudgetApp.currentGroupId
    projectId = parseInt $stateParams.projectId

    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.currentMembership = group.membershipFor(CurrentUser())

    Records.buckets.findOrFetchById(projectId).then (project) ->
      $scope.project = project
      $scope.status = project.status
      Records.comments.fetchByBucketId(projectId).then ->
        window.scrollTo(0, 0)

    $scope.back = ->
      Toast.hide()
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.statuses = ['draft', 'live', 'funded', 'done']
    $scope.statusIndex = 0
    
    $scope.toggleStatus = ->
      $scope.statusIndex++
      $scope.status = $scope.statuses[$scope.statusIndex % $scope.statuses.length]

    $scope.newComment = Records.comments.build(bucketId: projectId)

    $scope.createComment = ->
      $scope.newComment.save()
      $scope.newComment = Records.comments.build(bucketId: projectId)

    $scope.userCanStartFunding = ->
      $scope.currentMembership.isAdmin || $scope.project.author().id == $scope.currentMembership.member().id

    $scope.openForFunding = ->
      if $scope.project.target
        $scope.project.openForFunding()
        Toast.showAndRedirect('You launched a project for funding', "/projects/#{projectId}")
        $scope.back()
      else
        alert('Estimated funding target must be specified before funding starts')        

    $scope.editDraft = ->
      $location.path("/projects/#{projectId}/edit")

    $scope.userCanEditDraft = ->
      $scope.project && $scope.project.status == 'draft' && $scope.userCanStartFunding()

    $scope.fund = ->
      alert('funding button was clicked!')

    return