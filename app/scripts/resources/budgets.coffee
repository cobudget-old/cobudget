`// @ngInject`
window.Cobudget.Resources.Budget = (Restangular) ->

  get: (budget_id)->
    Restangular.one('budgets', budget_id).get()

  all: () ->
    Restangular.all('budgets').getList()

  myBudgets: ->
    #TODO restrict to only getting budgets visible by this user
    @allBudgets().$object

  getBudgetBuckets: (budget_id, state, limit)->
    state ||= "open"
    limit ||= ""
    Restangular.one('budgets', budget_id).customGET('buckets', {state: state, limit: limit})
  
  getBudgetContributors: (budget_id, state, limit) ->
    #console.log(budget_id)
    #state ||= "open"
    #limit ||= ""
    #Restangular.one('budgets', budget_id).customGET('buckets', {state: state, limit: limit})

    Restangular.oneUrl('contributors', 'http://api.cobudget.enspiral.info/cobudget/list_by_budget_accounts?budget_id='+budget_id).get()

    #contributors = {name: "charlie ablett", allocation_rights_cents: 178093}

#  createBudget: (budget_data)->
#    budgets.post('budgets', budget_data)
#
#  getUserAllocated: (user_allocations)->
#    sum = 0
#    angular.forEach user_allocations, (allocation)->
#      unless allocation.user_id == undefined
#        sum += allocation.amount
#    return sum
#  
#  #amount in balance (entries summed for budget) + amount allocated in current collection of buckets
#  getUserAllocatable: (account_balance, allocated_amount)->
#    parseFloat(account_balance) + allocated_amount

#
#  getUserAllocatedExceptBucket: (user_allocations, except_bucket_id)->
#    sum = 0
#    for allocation in user_allocations
#      unless allocation.bucket_id == except_bucket_id
#        sum += allocation
