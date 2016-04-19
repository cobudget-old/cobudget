null

### @ngInject ###
global.cobudgetApp.factory 'Session', ($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $state) ->
  new class Session
    create: (formData, options = {}) ->
      promise = $auth.submitLogin(formData)
      promise.then (user) =>
        global.cobudgetApp.currentUserId = user.id
        membershipsLoadedDeferred = $q.defer()
        global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise
        Records.users.updateProfile(utc_offset: moment().utcOffset())
        Records.memberships.fetchMyMemberships().then (data) =>
          membershipsLoadedDeferred.resolve(data)
          Records.users.fetchMe().then =>
            LoadBar.stop()
            switch options.redirectTo
              when 'group'
                # here is where we would likely intercept if user wasn't confirmed
                if CurrentUser().hasMemberships()
                  if CurrentUser().isConfirmed()
                    $location.path("/groups/#{CurrentUser().primaryGroup().id}")
                  else
                    LoadBar.start()
                    Records.users.requestReconfirmation().then =>
                      @clear()
                      $state.go('login', {email: CurrentUser().email})
                      LoadBar.stop()
                      content = "You have not yet confirmed your email address. We've sent another email to #{CurrentUser().email}. Please check your inbox to continue."
                      Dialog.alert(title: 'error!', content: content)
                else
                  @clear().then ->
                    $location.path('/')
                    Dialog.alert(title: 'error!', content: 'you have no active memberships')
              when 'group setup'
                $location.path("/setup_group")
      promise.catch ->
        LoadBar.stop()
      promise

    clear: ->
      deferred = $q.defer()
      if CurrentUser()
        $auth.signOut().then ->
          global.cobudgetApp.currentUserId = null
          deferred.resolve()
      else
        deferred.resolve()
      deferred.promise
