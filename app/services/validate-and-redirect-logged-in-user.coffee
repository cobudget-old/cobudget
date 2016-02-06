null

### @ngInject ###

global.cobudgetApp.factory 'ValidateAndRedirectLoggedInUser', ($auth, Error, LoadBar, $location, Records) ->
  ->
    LoadBar.start()
    Error.clear()
    $auth.validateUser()
    global.cobudgetApp.membershipsLoaded.then (data) ->
      groupId = data.groups[0].id
      $location.path("/groups/#{groupId}")
      LoadBar.stop()
