null 

### @ngInject ###
global.cobudgetApp.factory 'AllocationRecordsInterface', (config, BaseRecordsInterface, AllocationModel) -> 
  class AllocationRecordsInterface extends BaseRecordsInterface
    model: AllocationModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix 
    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId