angular.module('states.budget', ['controllers.buckets'])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('budgets',
    url: '/budgets/:budget_id'
    views:
      'main':
        templateUrl: '/views/budgets/budget.show.html'
        controller: 'BudgetController'
  ) #end state
  .state('budgets.buckets',
    url: '/buckets/:state'
    views:
      'header':
        templateUrl: '/views/budgets/budgets.header.html'
      'page':
        templateUrl: '/views/buckets/buckets.list.html'
      'sidebar':
        templateUrl: '/views/budgets/budget.sidebar.html'
        controller: ['$rootScope', '$scope', '$state', 'User', 'Budget', 'Bucket', 'Account', ($rootScope, $scope, $state, User, Budget, Bucket, Account)->
          $scope.state = $state.params.state
          $scope.chart_options = 
            segmentShowStroke : true
            segmentStrokeColor : "#fff"
            animation : false,

          $scope._transfer = {}

          $scope.ux = {}
          $scope.ux.show_transfer = false

          loadAccounts = ()->
            Budget.getBudget($state.params.budget_id).then (budget)->
              Account.accountsByBudget(budget).then (accounts)->
                $scope.accounts = accounts
              , (error)->
                console.log error
          loadAccounts()

          #TODO make the allocatable update here and in buckets collection. (try parent controller)
          #remove current user from accounts
          #
          $scope.transferAllocationRights = ->
            User.getAccountForBudget($state.params.budget_id).then (account)->
              account
            , (error)->
              console.log error
            .then (account)->
              Account.transferFunds(account.id, $scope._transfer.to_account.id, $scope._transfer.amount_dollars).then (transfer)->
                $scope._transfer = {}
                $scope.allocated = Budget.getUserAllocated($scope.user_allocations)
                $scope.allocatable = Budget.getUserAllocatable($scope.account_balance, $scope.allocated)

          prepareChart = ()->
            ch_vals = []
            angular.forEach($scope.user_allocations, (allocation)->
              ch_val = { value: allocation.amount, color: allocation.bucket_color }
              ch_vals.push ch_val
            )
            $scope.chart = ch_vals

          prepareGroupChart = ->
            group_allocations = []
            $scope.total_group_spend = 0
            for bucket in $scope.buckets
              allocation = {}
              allocation.amount = Bucket.sumBucketAllocations(bucket)
              $scope.total_group_spend += allocation.amount
              allocation.label = bucket.name
              allocation.bucket_color = bucket.color
              group_allocations.push allocation
            $scope.group_allocations = group_allocations
            #format for graph
            gch_vals = []
            for allocation in group_allocations
              ch_val =
                value: allocation.amount
                color: allocation.bucket_color
              gch_vals.push ch_val
            $scope.group_chart = gch_vals


          $scope.$on 'user-allocations-updated', (event, data)->
            $scope.buckets = data.buckets
            $scope.user_allocations = data.user_allocations
            User.getAccountForBudget($state.params.budget_id).then (account)->
              $scope.account_balance = account.allocation_rights_cents
              $scope.allocated = Budget.getUserAllocated($scope.user_allocations)
              $scope.allocatable = Budget.getUserAllocatable($scope.account_balance, $scope.allocated)
              prepareChart()
              prepareGroupChart()
            , (error)->
              console.log error


        ]
  ) #end state
  .state('budgets.propose_bucket',
    url: '/propose-bucket'
    views:
      'header':
        template: '<h2><a <a ui-sref="budgets.buckets({budget_id: budget.id})">{{budget.name}} </a> <span class="clr-medium-gray">> Propose a Bucket</span></h2>'
      'page':
        templateUrl: '/views/buckets/buckets.create.html'
        controller: 'BucketController'
      'sidebar':
        template: '<h2>Instructions</h2>'
  ) #end state
  .state('new_budget',
    url: '/new_budget'
    views:
      'main':
        templateUrl: '/views/budgets/budget.create.html'
        controller: ['$scope', '$state', 'Budget', 'flash', ($scope, $state, Budget, flash)->
          $scope._budget = {}
          $scope.createBudget = ()->
            Budget.createBudget($scope._budget).then (success)->
              flash('success', 'Budget Created.', 2000)
              $scope._budget = {}
              $state.go('admin.dashboard')
            , (error)->
              console.log error
        ]
  ) #end state
]) #end config

