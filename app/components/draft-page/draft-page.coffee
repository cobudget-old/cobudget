module.exports = 
  url: '/groups/:groupId/drafts/:draftId'
  template: require('./draft-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    window.scrollHeight = 0;

    groupId = parseInt $stateParams.groupId

    Records.groups.findOrFetchByKey(groupId).then (group) ->
      $scope.group = group

    $scope.back = ->
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.draft = {
      id : 1,
      name : '90 Second Enspiral Animation',
      authorName : 'Alanna Krause',
      ageInDays : 2,
      target : 500,
      description : 'We have been gearing up for a big external marketing campaign for the first half of the year. Nanz and I would like to raise this money to We have been gearing up for a big external marketing campaign for the first half of the year. Nanz and I would like to raise this money to.',
      status : 'draft',
      imageUrl : 'img/default-draft-image.svg'
    }

    return