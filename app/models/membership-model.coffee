global.cobudgetApp.factory 'MembershipModel', (BaseModel) ->
  class MembershipModel extends BaseModel
    @singular: 'membership'
    @plural: 'memberships'
    @indices: ['groupId', 'memberId']

    relationships: ->
      @belongsTo 'member', from: 'users'
      @belongsTo 'group'

    balance: ->
      parseFloat(@totalAllocations) - parseFloat(@totalContributions)