null

### @ngInject ###
global.cobudgetApp.factory 'Toast', ($mdToast) ->
  new class Toast
    show: (msg) ->
      $mdToast.show($mdToast.simple().content(msg))