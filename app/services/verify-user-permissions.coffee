null

### @ngInject ###
global.cobudgetApp.factory 'VerifyUserPermissions', (Toast, $location, $q, Records, ipCookie) ->
  new class VerifyUserPermissions
    forGroup: (groupId) ->
      deferred = $q.defer()
      Records.groups.findOrFetchById(groupId)
        .then (group) ->
          ipCookie('currentGroupId', groupId)
          deferred.resolve(group)
        .catch ->
          deferred.reject()
      deferred.promise