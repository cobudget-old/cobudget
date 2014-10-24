angular.module('budget-loader', [])
  .factory 'BudgetLoader' , ($routeParams, GroupService)->
  
    new class BudgetLoader
      init: ($rootScope) ->
        @rootScope = $rootScope

      loadAll: ->
        self = @
        GroupService.all().then (groups) ->
          self.rootScope.budgets = groups

      unloadAll: ->
        @rootScope.budgets = null

      setCurrent: ->
        self = @
        if !@rootScope.currentBudget || @rootScope.currentBudget.id != $routeParams.budget_id
          if $routeParams.budget_id
            GroupService.get($routeParams.budget_id).then (budget) ->
              self.setBudget budget

      getBudgetById: (budgets, id) ->
        return _.first(_.where(budgets, {'id': id}))

      getFirstBudget: (budgets) ->
        return _.first(budgets)

      setBudget: (groupId) ->
        @rootScope.currentBudget = @getBudgetById(@rootScope.budgets, groupId)

      defaultToFirstBudget: () ->
        @rootScope.currentBudget = @getFirstBudget(@rootScope.budgets)

      setBudgetByRoute: () ->
        if $routeParams.groupId
          @setBudget(parseInt($routeParams.groupId))
        else
          @defaultToFirstBudget()

      # @ahdinosaur asks "why do we want this?"
      initBudget: () ->
        if not @rootScope.currentBudget
          @setBudgetByRoute()