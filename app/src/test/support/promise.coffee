module.exports = promise =
  with: (args) ->
    @callback_args = args
    this
  then: (callback) ->
    callback(@callback_args)
