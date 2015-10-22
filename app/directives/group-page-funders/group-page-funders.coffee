null

### @ngInject ###
global.cobudgetApp.directive 'groupPageFunders', () ->
    restrict: 'E'
    template: require('./group-page-funders.html')
    replace: true
    controller: ($scope, Dialog) ->

      $scope.toggleMemberAdmin = (membership) ->
        membership.isAdmin = !membership.isAdmin
        membership.save()

      $scope.deleteMembership = (membership) ->
        Dialog.custom
          clickOutsideToClose: true
          template: require('./delete-membership-dialog.tmpl.html')
          scope: $scope
          preserveScope: true
          controller: ($scope, $mdDialog, Records) ->
            $scope.member = membership.member()
            $scope.cancel = ->
              $mdDialog.cancel()
            $scope.proceed = ->
              membership.destroy().then ->
                $mdDialog.hide()

      return