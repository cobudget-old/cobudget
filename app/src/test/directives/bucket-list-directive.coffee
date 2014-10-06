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
Budget =
  getBudgetBuckets: sinon.stub()

describe "bucket list directive", ->
  describe 'load buckets', ->
    beforeEach ->
      controller($rootScope, $scope, Budget)

    it 'does nothing if rootScope.currentBudget is empty', ->
      $rootScope.watch_callback(null)
      expect(Budget.getBudgetBuckets).to.not.have.been.called

    it 'loads buckets if currentBudget exists', ->
      Budget.getBudgetBuckets.returns promise.with [{id: 1, my_allocation_total: 100, name: 'bucket', percentage_funded: 20}, {id: 2, my_allocation_total: 100, name: 'bucket 2', percentage_funded: 20}]
      $rootScope.watch_callback {id: 3}
      expect(Budget.getBudgetBuckets).to.have.been.calledWith(3)
      expect($scope.buckets).to.deep.eq([{id: 1, my_allocation_total: 100, name: 'bucket', percentage_funded: 20}, {id: 2, my_allocation_total: 100, name: 'bucket 2', percentage_funded: 20}])

     

    

