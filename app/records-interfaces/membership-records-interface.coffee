null 

### @ngInject ###
global.cobudgetApp.factory 'MembershipRecordsInterface', (config, BaseRecordsInterface, MembershipModel) -> 
  class MembershipRecordsInterface extends BaseRecordsInterface
    model: MembershipModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix
    fetchMyMemberships: ->
      @fetch
        path: 'my_memberships'
    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId
