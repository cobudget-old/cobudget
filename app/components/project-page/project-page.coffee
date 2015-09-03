module.exports = 
  resolve: 
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/projects/:projectId'
  template: require('./project-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, Toast) ->
    
    groupId = global.cobudgetApp.currentGroupId
    projectId = parseInt $stateParams.projectId

    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.currentMembership = group.membershipFor(CurrentUser())

    Records.buckets.findOrFetchById(projectId).then (project) ->
      $scope.project = project
      $scope.status = project.status
      Records.comments.fetchByBucketId(projectId).then ->
        window.scrollTo(0, 0)

    $scope.back = ->
      Toast.hide()
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.statuses = ['draft', 'live', 'funded', 'done']
    $scope.statusIndex = 0
    
    $scope.toggleStatus = ->
      $scope.statusIndex++
      $scope.status = $scope.statuses[$scope.statusIndex % $scope.statuses.length]

    $scope.newComment = Records.comments.build(bucketId: projectId)

    $scope.createComment = ->
      $scope.newComment.save()
      $scope.newComment = Records.comments.build(bucketId: projectId)

    $scope.userCanStartFunding = ->
      $scope.currentMembership.isAdmin || $scope.project.author().id == $scope.currentMembership.member().id

    $scope.openForFunding = ->
      if $scope.project.target
        $scope.project.openForFunding().then ->
          $scope.back()
          Toast.showWithRedirect('You launched a project for funding', "/projects/#{projectId}")
      else
        alert('Estimated funding target must be specified before funding starts')        

    $scope.editDraft = ->
      $location.path("/projects/#{projectId}/edit")

    $scope.userCanEditDraft = ->
      $scope.project && $scope.project.status == 'draft' && $scope.userCanStartFunding()

    $scope.contribution = Records.contributions.build
      bucketId: projectId
      amount: 0

    $scope.fund = ->
      $scope.fundClicked = true

    $scope.totalAmountFunded = ->
      parseFloat($scope.project.totalContributions) + $scope.contribution.amount

    $scope.totalPercentFunded = ->
      $scope.totalAmountFunded() / parseFloat($scope.project.target) * 100

    $scope.maxAllowableContribution = ->
      _.min([$scope.project.amountRemaining, $scope.currentMembership.balance()])

    $scope.normalizeContributionAmount = ->
      if $scope.contribution.amount > $scope.maxAllowableContribution()
        $scope.contribution.amount = $scope.maxAllowableContribution()

    $scope.updateProgressBarColor = (contributionAmount) ->
      if contributionAmount > 0
        jQuery('.project-page__progress-bar .md-bar').addClass('project-page__progress-bar-green')
      else
        jQuery('.project-page__progress-bar .md-bar').removeClass('project-page__progress-bar-green')

    $scope.$watch ((scope) ->
      scope.contribution.amount
    ), $scope.updateProgressBarColor

    $scope.submitContribution = ->
      $scope.contribution.save().then ->
        location.reload()

    return