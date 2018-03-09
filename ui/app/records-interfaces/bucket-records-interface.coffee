null 

### @ngInject ###
global.cobudgetApp.factory 'BucketRecordsInterface', (config, BaseRecordsInterface, BucketModel) -> 
  class BucketRecordsInterface extends BaseRecordsInterface
    model: BucketModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix 
    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId