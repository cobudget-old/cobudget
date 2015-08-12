global.cobudgetApp.factory 'UserRecordsInterface', (config, BaseRecordsInterface, UserModel) -> 
  class UserRecordsInterface extends BaseRecordsInterface
    model: UserModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @restfulClient.apiPrefix = config.apiPrefix
    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId