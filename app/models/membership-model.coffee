global.cobudgetApp.factory 'MembershipModel', (BaseModel) ->
  class MembershipModel extends BaseModel
    @singular: 'membership'
    @plural: 'memberships'
    @indices: ['groupId', 'memberId']

    member: ->
      @recordStore.users.find(@memberId)

    group: ->
      @recordStore.groups.find(@groupId)

    balance: ->
      parseFloat(@totalAllocations) - parseFloat(@totalContributions)