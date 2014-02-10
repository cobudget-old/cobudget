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

  getCurrentUser: ->
    current_user

  refreshCurrentUser: ->
    @getUser(current_user.id).then (success)->
      current_user = success

])
