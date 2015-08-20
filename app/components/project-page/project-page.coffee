module.exports = 
  url: '/groups/:groupId/projects/:projectId'
  template: require('./project-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, ipCookie) ->
    
    groupId = parseInt $stateParams.groupId
    projectId = parseInt $stateParams.projectId

    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.currentMembership = group.membershipFor(CurrentUser.get())
      console.log('(project-page) currentMembership: ', $scope.currentMembership)

    Records.buckets.findOrFetchById(projectId).then (project) ->
      $scope.project = project
      $scope.status = project.status
      Records.comments.fetchByBucketId(projectId).then ->
        window.scrollTo(0, 0)

    $scope.back = ->
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
      $scope.project.openForFunding()
      ipCookie('newProjectOpenForFundingId', $stateParams.projectId)
      $scope.back()

    return