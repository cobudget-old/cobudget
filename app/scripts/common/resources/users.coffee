angular.module('resources.users', [])
.service("User", ['Restangular', (Restangular) ->
  users = Restangular.all('users')
  current_user = {}

  allUsers: ()->
    users.getList()

  getUser: (user_id)->
    Restangular.one('users', user_id).get()

  getUserAllocations: (user_id)->
    Restangular.one('buckets', budget_id).getList('allocations')

  updateUser: (user_data)->
    user = Restangular.one('users', user_data.id).customPUT(user_data)

  createUser: (user_data)->
    users.post('users', user_data)

  authUser: (params)->
    Restangular.all("users").customPOST(params, "authenticate")

  setCurrentUser: (user_data)->
    current_user = user_data
    detected_zone = Temporal.detect().timezone.name
    current_user.timezone = detected_zone

  getCurrentUser: ->
    current_user

  refreshCurrentUser: ->
    @getUser(current_user.id).then (success)->
      current_user = success

  getUserNameOrEmail: ->
    if current_user.name?
      current_user.name
    else
      current_user.email

  getAccountBalanceInBudget: (budget_id)->
    if current_user.accounts.length == 0
      console.log "No Accounts"
      return 0
    for acc in current_user.accounts
      if acc.budget_id == parseFloat(budget_id)
        if acc.allocation_rights_cents?
          return acc.allocation_rights_cents

  getAccountForBudget: (budget_id)->
    account = {}
    for acc in current_user.accounts
      if acc.budget_id == parseFloat(budget_id)
        account = Restangular.one('accounts', acc.id).get()
    account

])
