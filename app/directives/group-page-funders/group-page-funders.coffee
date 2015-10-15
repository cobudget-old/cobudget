null

### @ngInject ###
global.cobudgetApp.directive 'groupPageFunders', () ->
    restrict: 'E'
    template: require('./group-page-funders.html')
    replace: true
    controller: ($scope) ->

      $scope.makeMemberAdmin = (membership) ->
        membership.isAdmin = true
        membership.save()

      $scope.undoMemberAdmin = (membership) ->
        membership.isAdmin = false
        membership.save()

      return