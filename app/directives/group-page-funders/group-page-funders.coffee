null

### @ngInject ###
global.cobudgetApp.directive 'groupPageFunders', () ->
    restrict: 'E'
    template: require('./group-page-funders.html')
    replace: true
    controller: (Dialog, LoadBar, Records, $scope, Toast, $window) ->

      $scope.toggleMemberAdmin = (membership) ->
        membership.isAdmin = !membership.isAdmin
        membership.save()

      $scope.inviteAgain = (membership) ->
        Dialog.custom
          template: require('./reinvite-user-dialog.tmpl.html')
          scope: $scope
          controller: (Dialog, $mdDialog, Records, $scope, Toast) ->
            $scope.member = membership.member()
            $scope.cancel = ->
              $mdDialog.cancel()
            $scope.proceed = ->
              Records.memberships.reinvite(membership)
                .then ->
                  $scope.cancel()
                  Toast.show('Invitation sent!')
                .catch ->
                  Dialog.alert({title: 'Error!'})

      $scope.removeMembership = (membership) ->
        Dialog.custom
          template: require('./remove-membership-dialog.tmpl.html')
          scope: $scope
          controller: ($scope, $mdDialog, Records) ->
            $scope.member = membership.member()
            $scope.warnings = [
              "All of their funds will be removed from currently funding buckets",
              "All of their funds will be removed from the group",
              "All of their ideas will be removed from the group",
              "All of their funding buckets will be removed from the group and money will be refunded"
            ]
            $scope.cancel = ->
              $mdDialog.cancel()
            $scope.proceed = ->
              $mdDialog.hide()
              LoadBar.start()
              membership.archive().then ->
                LoadBar.stop()
                Dialog.alert(
                  title: 'Success!'
                  content: "#{$scope.member.name} was removed from #{$scope.group.name}"
                ).then ->
                  $window.location.reload()

      $scope.openManageFundsDialog = (funderMembership) ->
        Dialog.custom
          scope: $scope
          template: require('./../../directives/group-page-funders/manage-funds-dialog.tmpl.html')
          controller: ($mdDialog, $scope, Records) ->
            $scope.formData = {}
            $scope.mode = 'add'
            $scope.managedMembership = funderMembership
            $scope.managedMember = funderMembership.member()

            $scope.setMode = (mode) ->
              $scope.mode = mode

            $scope.normalizeAllocationAmount = ->
              allocationAmount = $scope.formData.allocationAmount || 0
              if allocationAmount + $scope.managedMembership.balance() < 0
                $scope.formData.allocationAmount = -$scope.managedMembership.balance()

            $scope.normalizeNewBalance = ->
              if $scope.formData.newBalance < 0
                $scope.formData.newBalance = 0

            $scope.isValidForm = ->
              ($scope.mode == 'add' && $scope.formData.allocationAmount) || ($scope.mode == 'change' && $scope.formData.newBalance)

            $scope.cancel = ->
              $mdDialog.cancel()

            $scope.createAllocation = ->
              if $scope.mode == 'add'
                amount = $scope.formData.allocationAmount
              if $scope.mode == 'change'
                amount = $scope.formData.newBalance - $scope.managedMembership.balance()
              params = {groupId: $scope.group.id, userId: $scope.managedMember.id, amount: amount }
              allocation = Records.allocations.build(params)
              allocation.save()
                .then (res) ->
                  Records.memberships.findOrFetchById($scope.managedMembership.id)
                  Dialog.alert(title: 'Success!')
                .catch (err) ->
                  Dialog.alert(title: 'Error!')
                .finally ->
                  $scope.cancel()

      return
