module.exports =
  url: '/'
  template: require('./landing-page.html')
  controller: ($scope) ->

    $scope.startGroup = ->
      console.log('ive been clicked!')

    return
