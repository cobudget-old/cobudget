module.exports = 
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    groupId = parseInt($stateParams.groupId) 
    Records.groups.findOrFetchByKey(groupId).then (group) ->
      $scope.group = group
      Records.buckets.fetchByGroupId(group.id)
      
    window.scrollHeight = 0;

    $scope.createProject = ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")

    $scope.showProject = (project) ->
      $location.path("/groups/#{$stateParams.groupId}/projects/#{project.id}")

    $scope.selectTab = (tabNum) ->
      $scope.tabSelected = parseInt tabNum

    $scope.funders = [
      {
        name: "Alanna Krause",
        balance: 1200
      },
      {
        name: "Derek Razo",
        balance: 800
      },
      {
        name: "Elon Musk",
        balance: 720
      },
      {
        name: "Jason Belling",
        balance: 300
      },
      {
        name: "Jessy Kate Schinger",
        balance: 110
      }
    ]