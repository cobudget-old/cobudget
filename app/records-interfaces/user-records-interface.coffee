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
      params = morph.toSnake(params)
      @remote.post('update_profile', user: params)

    inviteToCreateGroup: (params) ->
      @remote.post('invite_to_create_group', params)

    updatePassword: (params) ->
      @remote.post('update_password', params)
