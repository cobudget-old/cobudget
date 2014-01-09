angular.module("directives.manage_allocation_rights", [])
.directive('manageAllocationRights', ['Budget', (Budget) ->
  restrict: 'A'
  templateUrl: '/views/directives/manage_allocation_rights.html'
  scope:
    account: "=account"

  link: (scope, element, attr)->
    scope.ux = {}

    scope.account_display_name = ()->
      if scope.account.user_email? 
        scope.account.user_email 
      else
        scope.account.name
])
