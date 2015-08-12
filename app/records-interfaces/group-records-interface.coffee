null

### @ngInject ###
global.cobudgetApp.factory 'GroupRecordsInterface', (config, BaseRecordsInterface, GroupModel) -> 
  class GroupRecordsInterface extends BaseRecordsInterface
    model: GroupModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @restfulClient.apiPrefix = config.apiPrefix 