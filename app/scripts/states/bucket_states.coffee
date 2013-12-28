angular.module('states.bucket', ['controllers.buckets'])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
  $stateProvider.state('buckets',
    url: '/buckets/:bucket_id'
    views:
      'main':
        templateUrl: '/views/buckets/buckets.show.html'
        controller: (['$scope', '$state', ($scope, $state)->
        ]) #end controller
  ) #end state
  .state('buckets.edit',
    url: '/edit'
    views:
      'header':
        template: '
          <h2>Edit Bucket</h2>
        '
      'page':
        templateUrl: '/views/buckets/buckets.edit.html'
        controller: 'BucketController'
      'sidebar':
         template: '<h1>sidebar</h1>'
  ) #end state
]) #end config

