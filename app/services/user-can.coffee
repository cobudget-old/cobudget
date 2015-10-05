null

### @ngInject ###
global.cobudgetApp.factory 'UserCan', (Toast, $location, $q, Records, ipCookie, AuthenticateUser) ->
  new class UserCan
    fetchMemberships: ->
      deferred = $q.defer()
      AuthenticateUser().then ->
        Records.memberships.fetchMyMemberships().then (data) ->
          deferred.resolve(data)
      deferred.promise

    viewGroup: (groupId) ->
      deferred = $q.defer()

      @fetchMemberships().then (data) ->
        groups = _.find data.groups, (group) ->
          group.id == groupId

        if groups
          console.log('[UserCan.viewGroup] promise resolved!')
          deferred.resolve(true)
        else 
          console.log('[UserCan.viewGroup] promise rejected!')
          deferred.reject()

      deferred.promise