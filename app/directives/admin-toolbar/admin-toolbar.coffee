null

### @ngInject ###
global.cobudgetApp.directive 'adminToolbar', () ->
    restrict: 'E'
    template: require('./admin-toolbar.html')
    replace: true
    controller: ($scope) ->
      console.log('loaded lol')
