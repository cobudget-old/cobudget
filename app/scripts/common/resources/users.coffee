angular.module('resources.users', [])
.service("User", ['Restangular', (Restangular) ->
  users = Restangular.all('users')
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
])
