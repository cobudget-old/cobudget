angular.module("directives.manage_users", [])
.directive('manageUsers', ['User', (User) ->
  restrict: 'A'
  templateUrl: '/views/directives/manage_users.html'
  scope:
    user: "=user"

  link: (scope, element, attr)->
    scope.ux = {}

    scope.editUser = ->
      scope.ux.edit = true

    scope.toggleAdmin = (user)->
      if user.role == 'admin'
        user.role = ''
      else
        user.role = 'admin'


    scope.saveUser = ->
      scope.user.put().then (success)->
        scope.user = success
        delete scope.ux.edit
      , (error)->
        console.log error

    updateSingleField = (n,o)->
      if n != o
        scope.user.patch()

    scope.$watch "user.bg_color", (n,o)->
      updateSingleField(n,o)

    scope.$watch "user.role", (n,o)->
      updateSingleField(n,o)

    scope.$watch "user.fg_color", (n,o)->
      updateSingleField(n,o)

])
