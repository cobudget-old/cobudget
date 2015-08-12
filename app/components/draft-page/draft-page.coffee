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
      console.log(draft)
      $scope.draft = draft

    $scope.back = ->
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    return