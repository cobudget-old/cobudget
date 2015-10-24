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
          template: require('./delete-membership-dialog.tmpl.html')
          scope: $scope
          controller: ($scope, $mdDialog, Records) ->
            $scope.member = membership.member()
            $scope.cancel = ->
              $mdDialog.cancel()
            $scope.proceed = ->
              membership.destroy().then ->
                $mdDialog.hide()

      return