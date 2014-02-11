angular.module('states.budget', ['controllers.buckets'])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('budgets',
    url: '/budgets/:budget_id'
    views:
      'main':
        resolve:
          currentUser: ["User", "ENV", (User, ENV)->
            if ENV.skipSignIn
              User.getUser(1).then (success)->
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
    url: '/buckets'
    views:
      'header':
        template: '
          <h2>{{budget.name}}</h2>
        '
      'page':
        templateUrl: '/views/buckets/buckets.list.html'
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
]) #end config

