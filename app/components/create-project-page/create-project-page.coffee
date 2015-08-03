module.exports = 
  url: '/groups/:groupId/projects/new'
  template: require('app/components/create-project-page/create-project-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    $scope.cancel = () ->
      $location.path("/groups/#{$stateParams.groupId}")
