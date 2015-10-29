global.cobudgetApp.factory 'UserRecordsInterface', (config, BaseRecordsInterface, UserModel) -> 
  class UserRecordsInterface extends BaseRecordsInterface
    model: UserModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix

    confirmAccount: (params)->
      @remote.post('confirm_account', params)
