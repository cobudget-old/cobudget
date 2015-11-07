null

### @ngInject ###
global.cobudgetApp.factory 'UserModel', (BaseModel) ->
  class UserModel extends BaseModel
    @singular: 'user'
    @plural: 'users'
    @serializableAttributes: ['email']

    relationships: ->
      @hasMany 'memberships', with: 'memberId'

    groups: ->
      groupIds = _.map @memberships(), (membership) ->
        membership.groupId
      @recordStore.groups.find(groupIds)

    primaryGroup: ->
      @groups()[0]