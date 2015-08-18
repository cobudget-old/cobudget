module.exports = 
  url: '/groups/:groupId/drafts/:draftId'
  template: require('./draft-page.html')
  controller: ($scope, Records, $stateParams, $location) ->

    groupId = parseInt $stateParams.groupId
    draftId = parseInt $stateParams.draftId

    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group

    Records.buckets.findOrFetchById(draftId).then (draft) ->
      $scope.draft = draft
      Records.comments.fetchByBucketId(draftId).then ->
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
    $scope.status = $scope.statuses[0]
    
    $scope.toggleStatus = ->
      $scope.statusIndex++
      $scope.status = $scope.statuses[$scope.statusIndex % $scope.statuses.length]

    $scope.newComment = Records.comments.build(bucketId: draftId)

    $scope.createComment = ->
      $scope.newComment.save()
      $scope.newComment = Records.comments.build(bucketId: draftId)

    return