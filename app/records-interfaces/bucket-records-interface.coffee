null 

### @ngInject ###
global.cobudgetApp.factory 'BucketRecordsInterface', (BaseRecordsInterface, BucketModel) -> 
  class BucketRecordsInterface extends BaseRecordsInterface
    model: BucketModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @restfulClient.apiPrefix = 'http://localhost:3000/api/v1'
    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId