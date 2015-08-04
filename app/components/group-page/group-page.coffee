module.exports = 
  url: '/groups/:groupId'
  template: require('app/components/group-page/group-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    groupId = parseInt($stateParams.groupId) 
    Records.groups.findOrFetchByKey(groupId).then (group) ->
      $scope.group = group
      Records.buckets.fetchByGroupId(group.id)

    window.scrollHeight = 0;

    $scope.createProject = () ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")

    $scope.drafts = [
      {
        name: "90 Second Enspiral Animation", 
        author: "Alanna Krause",
        age: 3
      },
      {
        name: "Laser Cutter", 
        author: "Eugene Lynch",
        age: 5
      },
      {
        name: "Support Loomio crowdfunding campaign", 
        author: "Richard Bartlett",
        age: 6
      },
      {
        name: "Social Enterprise Weekend", 
        author: "Michael",
        age: 10
      }
    ]