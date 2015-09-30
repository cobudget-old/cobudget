null

### @ngInject ###
global.cobudgetApp.factory 'VerifyUserPermissions', (Toast, $location, $q, Records, ipCookie) ->
  new class VerifyUserPermissions
    forGroup: (groupId) ->
      deferred = $q.defer()
      Records.groups.findOrFetchById(groupId)
        .then (group) ->

          # after signing out and signing back in as a different user, the above promise 
          # resolves, causing parts of the page to load, when they shouldn't.
          # i think this is caused by the lokijs records still being cached locally.

          # if this is the case, i see a few ways to avoid this. first way is to 
          # fetch only, instead of find. the other way is (and i like this way more), 
          # is to destroy the cached lokijs database on signout, so that nothing is 
          # cached for the next user who logs in
          
          alert('verifyUserPermissions promise was resolved!!!!')
          ipCookie('currentGroupId', groupId)
          deferred.resolve(group)
        .catch ->
          alert('verifyUserPermissions promise was rejected')
          deferred.reject()
      deferred.promise