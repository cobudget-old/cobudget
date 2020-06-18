null

### @ngInject ###
global.cobudgetApp.factory 'LoadBar', ($rootScope) ->
  new class LoadBar

    start: (args) ->
      args = args || {}
      $rootScope.loadingScreenMsg = args.msg
      $rootScope.$broadcast('loading')

    updateMsg: (msg) ->
      $rootScope.loadingScreenMsg = msg

    stop: ->
      $rootScope.loadingScreenMsg = null
      $rootScope.$broadcast('loaded')
