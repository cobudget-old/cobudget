null

### @ngInject ###
global.cobudgetApp.factory 'MembershipModel', (BaseModel) ->
  class MembershipModel extends BaseModel
    @singular: 'membership'
    @plural: 'memberships'
    @indices: ['groupId', 'memberId']
    @serializableAttributes: ['isAdmin', 'closedAdminHelpCardAt', 'closedMemberHelpCardAt']

    relationships: ->
      @belongsTo 'member', from: 'users'
      @belongsTo 'group'

    isPending: ->
      !@member().isConfirmed()

    archive: ->
      @remote.postMember(@id, 'archive')
