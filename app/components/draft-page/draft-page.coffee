module.exports = 
  url: '/groups/:groupId/drafts/:draftId'
  template: require('./draft-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    window.scrollHeight = 0;

    groupId = parseInt $stateParams.groupId
    draftId = parseInt $stateParams.draftId

    Records.groups.findOrFetchByKey(groupId).then (group) ->
      $scope.group = group

    Records.buckets.findOrFetchByKey(draftId).then (draft) ->
      $scope.draft = draft
      Records.comments.fetchByBucketId(draftId)

    $scope.back = ->
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.newComment = Records.comments.build()

    $scope.createComment = ->
      console.log('newComment: ', $scope.newComment)
      $scope.newComment.save()

    return