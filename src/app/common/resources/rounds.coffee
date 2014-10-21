`// @ngInject`
angular.module('cobudget').service 'Round',  (Restangular) ->

	get: (round_id)->
		Restangular.one('rounds', round_id).get()
