null

### @ngInject ###
global.cobudgetApp.factory 'GroupRecordsInterface', (config, BaseRecordsInterface, GroupModel) -> 
  class GroupRecordsInterface extends BaseRecordsInterface
    model: GroupModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix 

    getAll: ->
      @remote.getCollection().then (data) ->
        camelize(data.groups)