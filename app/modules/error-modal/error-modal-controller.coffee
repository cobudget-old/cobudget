debug = require('debug')("error-modal")

### @ngInject ###
module.exports = ($scope, $modalInstance, error) ->

  debug("error", error)
  $scope.error = error

  if error.data
    $scope.data = JSON.stringify(error.data, null, 2)

  $scope.close = ->
    $modalInstance.dismiss('close')
