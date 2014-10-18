`// @ngInject`
angular.module('cobudget').service 'Round',  (Restangular) ->

	get: (round_id)->
		Restangular.one('round', round_id).get()
