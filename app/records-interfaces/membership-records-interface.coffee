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

    fetchOneMembership: (groupId) ->
      @fetch
        path: 'my_memberships'
        params:
          group_id: groupId

    fetchByGroupId: (groupId) ->
      @fetch
        params:
          group_id: groupId

    invite: (membership) ->
      @remote.postMember(membership.id, 'invite')
