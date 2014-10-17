expect = require('../support/expect')
promise = require('../support/promise')
sinon = require('sinon')

require '../support/setup'
require '../../app/scripts/directives/bucket-list/bucket-list-directive'

controller = window.Cobudget.Directives.BucketList().controller

$rootScope =
  $watch: (key, callback) ->
    @watch_callback = callback

$scope = {}
Organization =
  getBudgetBuckets: sinon.stub()

describe "bucket list directive", ->
  describe 'load buckets', ->
    beforeEach ->
      controller($rootScope, $scope, Organization)

    it 'does nothing if rootScope.currentBudget is empty', ->
      $rootScope.watch_callback(null)
      expect(Organization.getBudgetBuckets).to.not.have.been.called

    it 'loads buckets if currentBudget exists', ->
      Organization.getBudgetBuckets.returns promise.with [{id: 1, my_allocation_total: 100, name: 'bucket', percentage_funded: 20}, {id: 2, my_allocation_total: 100, name: 'bucket 2', percentage_funded: 20}]
      $rootScope.watch_callback {id: 3}
      expect(Organization.getBudgetBuckets).to.have.been.calledWith(3)
      expect($scope.buckets).to.deep.eq([{id: 1, my_allocation_total: 100, name: 'bucket', percentage_funded: 20}, {id: 2, my_allocation_total: 100, name: 'bucket 2', percentage_funded: 20}])

     

    

