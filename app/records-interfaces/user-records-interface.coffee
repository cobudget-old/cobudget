global.cobudgetApp.factory 'UserRecordsInterface', (config, BaseRecordsInterface, UserModel) -> 
  class UserRecordsInterface extends BaseRecordsInterface
    model: UserModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix

    confirmAccount: (params)->
      @remote.post('confirm_account', params)

    requestPasswordReset: (params) ->
      @remote.post('request_password_reset', params)

    resetPassword: (params) ->
      @remote.post('reset_password', params)

    updateProfile: (params) ->
      @remote.post('update_profile', user: params)