angular.module('states.budget', ['controllers.buckets'])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('budgets',
    url: '/budgets/:budget_id'
    views:
      'main':
        resolve:
          currentUser: ["User", "ENV", (User, ENV)->
            if ENV.skipSignIn
              if _.isEmpty(User.getCurrentUser())
                User.getUser(1).then (success)->
                  User.setCurrentUser(success)
              else
                User.getUser(User.getCurrentUser().id).then (success)->
                  User.setCurrentUser(success)
            else
              if _.isEmpty(User.getCurrentUser())
                false
              else
                User.getUser(User.getCurrentUser().id).then (success)->
                  User.setCurrentUser(success)
          ]
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
        controller: ['$scope', ($scope)->
          $scope.$parent.load()
        ]
      'sidebar':
        templateUrl: '/views/budgets/budget.sidebar.html'
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

