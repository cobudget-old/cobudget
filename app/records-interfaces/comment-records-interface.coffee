null 

### @ngInject ###
global.cobudgetApp.factory 'CommentRecordsInterface', (config, BaseRecordsInterface, CommentModel) -> 
  class CommentRecordsInterface extends BaseRecordsInterface
    model: CommentModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix 
    fetchByBucketId: (bucketId) ->
      @fetch
        params:
          bucket_id: bucketId
