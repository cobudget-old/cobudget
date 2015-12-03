null

### @ngInject ###
global.cobudgetApp.factory 'AllocationModel', (BaseModel) ->
  class AllocationModel extends BaseModel
    @singular: 'allocation'
    @plural: 'allocations'
    @indices: ['groupId', 'userId']
    @serializableAttributes: ['groupId', 'userId', 'amount']

    relationships: ->
      @belongsTo 'group'
      @belongsTo 'user'
