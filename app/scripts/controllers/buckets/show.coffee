`// @ngInject`
window.Cobudget.Controllers.BucketShow = ($scope, $route, Bucket) ->
  console.log($route.current.params)
  if $route.current.params.bucket_id
    $scope.bucket = Bucket.get($route.current.params.bucket_id).$object
