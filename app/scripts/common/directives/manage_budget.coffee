angular.module("directives.manage_budget", [])
.directive('manageBudget', ['Budget', 'Account', (Budget, Account) ->
  restrict: 'A'
  templateUrl: '/views/directives/manage_budget.html'
  scope:
    budget: "=budget"

  link: (scope, element, attr)->
    scope.budget_account = {}
    scope.budget.accounts = []
    scope.active_budget = undefined
    scope.ux = {}

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
            console.log "IT"
            scope.budget_account = acc
      , (error)->
        console.log error

    scope.loadAccounts()

    scope.refreshBudgetAccount = ()->
      Account.getAccount(scope.budget_account.id).then (success)->
        scope.budget_account = success

    scope.updateAllocationRights = ()->
      #must manually incriment due to promise...
      i = 0
      for acc in scope.budget.accounts
        if acc._allocation_rights
          Account.grantAllocationRights(acc).then (success)->
            acc._allocation_rights = 0
            scope.budget.accounts[i] = success
            scope.refreshBudgetAccount()
            i++
            #scope.loadAccounts()
          , (error)->
            console.log error
])
