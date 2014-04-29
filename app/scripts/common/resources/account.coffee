angular.module('resources.accounts', ['ngResource'])
.service("Account", ['Restangular', (Restangular) ->
  accounts = Restangular.all('accounts')
  allAccounts: ()->
    accounts.getList()
  getAccount: (account_id)->
    Restangular.one('accounts', account_id).get()
  accountsByBudget: (budget)->
    budget.getList('accounts').then (acc_success)->
        acc_success
      , (error)->
        console.log error
  grantAllocationRights: (account)->
    #TODO Admin stuff
    params = 
      admin_id: 1
      amount: account._allocation_rights
    Restangular.one('users', account.user_id).get().then (success)->
      success.post("grant_allocation_rights/#{account.budget_id}", params)

  transferFunds: (from_account_id, to_account_id, amount_in_dollars)->
    Restangular.one('accounts', from_account_id).customPOST({amount_dollars: amount_in_dollars, to_account_id: to_account_id}, 'transfer')
])
