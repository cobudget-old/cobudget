`// @ngInject`
angular.module('cobudget').factory 'AllocationModel',  (UserModel) ->
  class AllocationModel
    constructor: (data = {}) ->
      @id = data.id
      @user = new UserModel(data.user)
      @roundId = data.round_id
      @amountCents = data.amount_cents