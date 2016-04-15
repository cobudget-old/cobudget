module.exports =
  url: '/about'
  template: require('./about-page.html')
  controller: ($location, $scope) ->

    $scope.redirectToLandingPage = ->
      $location.path('/')

    return
