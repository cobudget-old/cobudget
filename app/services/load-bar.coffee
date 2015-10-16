null

### @ngInject ###
global.cobudgetApp.factory 'LoadBar', ($rootScope) ->
  new class LoadBar

    start: ->
      $rootScope.$broadcast('loading')          

    stop: ->
      $rootScope.$broadcast('loaded')