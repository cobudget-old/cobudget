angular.module('states.user', [])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('user-dashboard', 
    url: '/dashboard'
    views:
      'main':
        templateUrl: '/views/user/dashboard.html'
        controller: (['$q', '$scope', '$state', 'User', 'Budget', 'Time', ($q, $scope, $state, User, Budget, Time)->
          #util, and dupe, where should it go tho
          formatBucketTimes = (bucket)->
            bucket.created_at_ago = Time.ago(bucket.created_at)
            if bucket.funded_at?
              bucket.funded_at_ago = Time.ago(bucket.funded_at)
            if bucket.cancelled_at?
              bucket.cancelled_at_ago = Time.ago(bucket.cancelled_at)
            bucket

          formatBuckets = (buckets)->
            for bucket, i in buckets
              buckets[i] = formatBucketTimes(buckets[i])
            buckets

          getUserAccountBalanceForBudget = (budget_id)->
            accounts = User.getCurrentUser().accounts
            amt = 0
            angular.forEach accounts, (account)->
              if account.budget_id == budget_id
                amt = account.allocation_rights_cents
            amt

          setBudgetsAccountBalances = (budgets_array)->
            for budget, i in budgets_array
              budgets_array[i].user_account_balance = getUserAccountBalanceForBudget(budget.id)
            budgets_array

          loadBudgets = ->
            accounts = User.getCurrentUser().accounts
            promises = []
            angular.forEach accounts, (account)->
              promises.push Budget.getBudget(account.budget_id)
            $q.all(promises).then (budgets_array)->
              budgets_array = setBudgetsAccountBalances(budgets_array)
              $scope.budgets = budgets_array
              return budgets_array

          loadBudgetsRecentlyOpened = (budgets_array)->
            angular.forEach budgets_array, (budget)->
              Budget.getBudgetBuckets(budget.id, 'open', 5).then (buckets)->
                budget.recently_opened_buckets = formatBuckets(buckets)
                return buckets
            , (error)->
              console.log error
             
          loadBudgetsRecentlyFunded = (budgets_array)->
            angular.forEach budgets_array, (budget)->
              Budget.getBudgetBuckets(budget.id, 'funded', 5).then (buckets)->
                budget.recently_funded_buckets = formatBuckets(buckets)
                return buckets
            , (error)->
              console.log error

          loadBudgetsRecentlyCancelled = (budgets_array)->
            angular.forEach budgets_array, (budget)->
              Budget.getBudgetBuckets(budget.id, 'cancelled', 5).then (buckets)->
                budget.recently_cancelled_buckets = formatBuckets(buckets)
                return buckets
            , (error)->
              console.log error

          loadBudgets()
          .then(loadBudgetsRecentlyOpened) #takes budgets array
          .then(loadBudgetsRecentlyFunded) #takes budgets array
          .then(loadBudgetsRecentlyCancelled) #takes budgets array

        ]) #end controller
  ) #end state
])
