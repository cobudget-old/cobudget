angular.module('states.budget', ['controllers.buckets'])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('budgets',
    url: '/budgets/:budget_id'
    views:
      'main':
        templateUrl: '/views/budgets/budget.show.html'
        controller: (['$scope', '$state', ($scope, $state)->
        ]) #end controller
  ) #end state
  .state('budgets.buckets',
    url: '/buckets'
    views:
      'bucket-list':
        templateUrl: '/views/buckets/buckets.list.html'
        controller: (['$scope', '$rootScope', '$state', "Bucket", ($scope, $rootScope, $state, Bucket)->
          $scope.buckets = []
          #set up rules for slider
          $scope.allocatable = 4445
          $scope.remainder_allocatable = $scope.allocatable

          setMinMax = (bucket)->
            if bucket.minimum_cents?
              bucket.minimum = parseFloat(bucket.minimum_cents) / 100
            else
              bucket.minimum = 0
            if bucket.maximum_cents?
              bucket.maximum = parseFloat(bucket.maximum_cents) / 100
            else
              bucket.maximum = 0
            bucket

          Bucket.query(budget_id: $state.params.budget_id, (response)->
            for b in response
              b.allocation = 0
              setMinMax(b)
              $scope.buckets.push b
          )

          $rootScope.channel.bind('bucket_created', (bucket) ->
            setMinMax(bucket.bucket)
            $scope.buckets.unshift bucket.bucket
            $scope.$apply()
          )

          $rootScope.channel.bind('bucket_updated', (bucket) ->
            for i in [0...$scope.buckets.length]
              bk = $scope.buckets[i]
              if bk.id == bucket.bucket.id
                $scope.buckets[i] = bucket.bucket
                setMinMax($scope.buckets[i])
            $scope.$apply()
          )
        ]) #end controller
       'sidebar@':
         template: '<h1>sidebar</h1>'
  ) #end state
  .state('budgets.propose_bucket',
    url: '/propose-bucket'
    views:
      'bucket-create':
        templateUrl: '/views/buckets/buckets.create.html'
        controller: 'BucketController'
      'sidebar@':
        template: '<h1>Instructions</h1>'
  ) #end state
]) #end config

