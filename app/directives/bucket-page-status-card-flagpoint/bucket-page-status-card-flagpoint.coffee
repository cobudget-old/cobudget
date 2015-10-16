null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageStatusCardFlagpoint', () ->
    scope: 
      status: "@"
      bucket: "="
    restrict: 'E'
    template: require('./bucket-page-status-card-flagpoint.html')
    replace: true
    controller: ($scope) ->

      $scope.flagpointText = () ->
        switch $scope.status
          when 'draft' then 'Idea'
          when 'live' then 'Funding'
          when 'funded' then 'Funded'
          when 'done' then 'Done'

      return