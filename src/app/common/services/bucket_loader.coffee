angular.module('bucket-loader', [])
  .factory 'BucketLoader' , (Restangular, $routeParams, $stateParams, Round, Organization)->
  
    new class BucketLoader
      getBucket: (bucket_id) ->
        Bucket.get(bucket_id)

        #Restangular.one('round', round_id).get().then (response) ->
        #  console.log('get round res', response.buckets)
        #  response.buckets