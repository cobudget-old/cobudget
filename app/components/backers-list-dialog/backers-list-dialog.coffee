module.exports = (params) ->
  template: require('./backers-list-dialog.html')
  scope: params.scope
  controller: (Dialog, $mdDialog, $scope) ->

    groupedContributions = _.groupBy params.contributions, 'userId'
    $scope.backers = _.map groupedContributions, (contributions) ->
      callback = (sum, contribution) ->
        sum + contribution.amount
      totalContributionAmount = _.reduce contributions, callback, 0
      {name: contributions[0].user().name, contributionAmount: totalContributionAmount}

    $scope.ok = ->
      $mdDialog.cancel()
