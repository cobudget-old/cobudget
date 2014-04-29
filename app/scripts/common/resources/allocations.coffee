angular.module('resources.allocations', [])
.service("Allocation", ['Restangular', (Restangular) ->
  allocations = Restangular.all('allocations')
  updateAllocation: (allocation_data)->
    allocation = Restangular.one('allocations', allocation_data.id).customPUT(allocation_data)
  createAllocation: (allocation_data)->
    allocations.post('allocations', allocation_data)
])
