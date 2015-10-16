null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageStatusCard', () ->
    restrict: 'E'
    template: require('./bucket-page-status-card.html')
    replace: true
    controller: ($scope, $state, Toast) ->

      return