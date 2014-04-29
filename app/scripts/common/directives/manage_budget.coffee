angular.module("directives.manage_budget", [])
.directive('manageBudget', ['Budget', 'Account', 'User', (Budget, Account, User) ->
  restrict: 'A'
  templateUrl: '/views/directives/manage_budget.html'
  scope:
    budget: "=budget"
    users: "=users"

  link: (scope, element, attr)->
    User.refreshCurrentUser()
    scope.budget_account = {}
    scope.budget.accounts = []
    scope.active_budget = undefined
    scope._account = {}
    scope._n_account = {}
    scope._n_account._allocation_rights = 0
    scope.ux = {}
    scope.ux.add_user_form = false

    scope.ux.toggle = ()->
      if scope.active_budget == scope.budget.id
        scope.active_budget = undefined
      else
        scope.active_budget = scope.budget.id

    scope.loadAccounts = ()->
      scope.budget.accounts = []
      Account.accountsByBudget(scope.budget).then (success)->
        for acc in success
          if acc.user_id?
            scope.budget.accounts.push acc
          else
            scope.budget_account = acc
      , (error)->
        console.log error

    scope.loadAccounts()

    scope.check = ->
      console.log scope.$parent.$parent

    scope.refreshBudgetAccount = ()->
      Account.getAccount(scope.budget_account.id).then (success)->
        scope.budget_account = success

    scope.createAllocationRights = ->
      account = {}
      account.user_id = scope._n_account.user.id
      account._allocation_rights = scope._n_account._allocation_rights
      account.budget_id = scope.active_budget

      Account.grantAllocationRights(account).then (success)->
        scope.budget.accounts.unshift success
        scope._n_account = {}
        scope._n_account._allocation_rights = 0
        scope.afterAllocationRights()

    scope.updateAllocationRights = ->
      for acc in scope.budget.accounts
        if acc._allocation_rights
          acc._allocation_rights = acc._allocation_rights
          Account.grantAllocationRights(acc).then (success)->
            for acc, i in scope.budget.accounts
              if acc.id == success.id
                scope.budget.accounts[i] = success
            scope.afterAllocationRights()
          , (error)->
            console.log error

    scope.afterAllocationRights = ->
      scope.refreshBudgetAccount()
      User.refreshCurrentUser()

])
