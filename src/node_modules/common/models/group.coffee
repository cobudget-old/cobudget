`// @ngInject`
angular.module('cobudget').factory 'GroupModel',  (RoundModel) ->
  class GroupModel
    constructor: (data = {}) ->
      @id = data.id
      @name = data.name
      @latestRound = new RoundModel(data.latest_round)