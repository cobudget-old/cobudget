'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'cobudget'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'BucketController', {
      $scope: scope
    }

  it 'have tests', () ->
    expect(1).toBe 1
