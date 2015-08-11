global.cobudgetApp.factory 'UserRecordsInterface', (BaseRecordsInterface, UserModel) -> 
  class UserRecordsInterface extends BaseRecordsInterface
    model: UserModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @restfulClient.apiPrefix = 'http://localhost:3000/api/v1'