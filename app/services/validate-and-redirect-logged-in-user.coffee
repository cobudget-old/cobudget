null

### @ngInject ###

global.cobudgetApp.factory 'ValidateAndRedirectLoggedInUser', ($auth, Error, LoadBar, $location, Records) ->
  ->
    $auth.validateUser().then ->
      LoadBar.start()
      Error.clear()
      global.cobudgetApp.membershipsLoaded.then (data) ->
        groupId = data.groups[0].id
        $location.path("/groups/#{groupId}")
        LoadBar.stop()
