null 

### @ngInject ###
global.cobudgetApp.factory 'BucketRecordsInterface', (config, BaseRecordsInterface, BucketModel) -> 
  class BucketRecordsInterface extends BaseRecordsInterface
    model: BucketModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @restfulClient.apiPrefix = config.apiPrefix 
    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId