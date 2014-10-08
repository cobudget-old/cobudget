`// @ngInject`
window.Cobudget.Resources.Round = (Restangular) ->

	get: (round_id)->
		Restangular.one('round', round_id).get()