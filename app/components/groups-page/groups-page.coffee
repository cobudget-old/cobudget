module.exports = 
  url: '/groups'
  template: require('app/components/groups-page/groups-page.html')
  controller: ($scope, $auth, Records) ->

    window.scrollHeight = 0;

    $scope.group = 
      name: "Enspiral"
      personalFunds: 3500
      totalFunds: 15000

    $scope.projects = [
      {
        name: "Improve remote meeting experience",
        amountRemaining: 2300
      },
      {
        name: "Repay outstanding debts",
        amountRemaining: 500
      },
      {
        name: "Enspiral Stickers!!!",
        amountRemaining: 50
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