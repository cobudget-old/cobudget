null # ridiculous hack due to coffee class extends

### @ngInject ###
global.cobudgetApp.factory 'GroupRecordsInterface', (BaseRecordsInterface, GroupModel) -> 
  class GroupRecordsInterface extends BaseRecordsInterface
    model: GroupModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @restfulClient.apiPrefix = 'http://localhost:3000/api/v1'
