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

    $scope.back = ->
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.comments = [
      {
        authorName: "Jasmine Park",
        text: "WOW I have been waiting so long for something like this",
      },
      {
        authorName: "Jason Mraz",
        text: "Awesome idea. This will be a really valuable asset when we're talking to new clients. If possible, I would love to be involved in writing the text for the voiceover.",
      },
      {
        authorName: "Eddie Kingler",
        text: "I'm concerned about this. IMHO we're not really ready for a marketing blitz.",
      },
    ]
    
    return