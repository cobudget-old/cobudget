`// @ngInject`

angular.module('cobudget').service 'Contribution', (Restangular) ->
 
  #get details of contribution
  get: (id) ->
    Restangular.one('contributions', id).get()

  create: (contribution) ->
    Restangular.all('contributions').post(contribution)

  update: (contribution) ->
    Restangular.one('contributions', contribution.id).customPUT(contribution)

  save: (contribution) ->
    if contribution.id
      @update(contribution)
    else
      @create(contribution)