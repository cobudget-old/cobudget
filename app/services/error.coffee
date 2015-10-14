null

### @ngInject ###
global.cobudgetApp.factory 'Error', ($rootScope) ->
  new class Error
    set: (msg) ->
      $rootScope.$broadcast('set error', msg)          

    clear: ->
      $rootScope.$broadcast('clear error')