null

### @ngInject ###
global.cobudgetApp.factory 'MembershipModel', (BaseModel) ->
  class MembershipModel extends BaseModel
    @singular: 'membership'
    @plural: 'memberships'
    @indices: ['groupId', 'memberId']
    @serializableAttributes: ['isAdmin']

    relationships: ->
      @belongsTo 'member', from: 'users'
      @belongsTo 'group'

    balance: ->
      parseFloat(@totalAllocations) - parseFloat(@totalContributions)

    isPending: ->
      @member().isPendingConfirmation

    archive: ->
      @remote.postMember(@id, 'archive')
