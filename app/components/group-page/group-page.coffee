module.exports = 
  url: '/groups/:groupId'
  template: require('app/components/group-page/group-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    # console.log('groupId: ', $stateParams.groupId)
    # Records.groups.findOrFetchByKey($stateParams.groupId).then (group) =>
    #   console.log('found group: ', Records.groups.find($stateParams.groupId))
    #   console.log('group: ', group)
      # console.log('group: ', Records.groups.find($stateParams.groupId))
      # console.log('RecordsGroupCollection: ', Records.groups.collection)
      # $scope.group = group

      # $scope.group = group
      # Records.buckets.fetchByGroupId(group.id)
    
    window.scrollHeight = 0;

    $scope.createProject = () ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")

    $scope.group = 
      id: 1
      name: "Enspiral"
      personalFunds: 3500
      totalFunds: 15000

    $scope.projects = [
      {
        name: "Improve remote meeting experience",
        amountRemaining: 2300,
        percentFunded: 10
      },
      {
        name: "Repay outstanding debts",
        amountRemaining: 500,
        percentFunded: 70
      },
      {
        name: "Enspiral Stickers!!!",
        amountRemaining: 50,
        percentFunded: 92
      }
    ]

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