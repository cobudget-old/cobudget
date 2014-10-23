`// @ngInject`
angular.module('cobudget').service 'Round',  (Restangular, $q) ->

  get: (round_id) ->
    Restangular.one('rounds', round_id).get()

