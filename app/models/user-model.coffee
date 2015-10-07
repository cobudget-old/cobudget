null

### @ngInject ###
global.cobudgetApp.factory 'UserModel', (BaseModel) ->
  class UserModel extends BaseModel
    @singular: 'user'
    @plural: 'users'

    relationships: ->
      @hasMany 'memberships', with: 'memberId'

    groups: ->
      groupIds = _.map @memberships(), (membership) ->
        membership.groupId
      @recordStore.groups.find(groupIds)