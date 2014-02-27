angular.module('resources.comments', [])
.service("Comment", ['Restangular', (Restangular) ->
  commentsByBucket: (bucket_id)->
    Restangular.one('buckets', bucket_id).customGET('comments')
  createComment: (bucket_id, comment_data)->
    Restangular.one('buckets', bucket_id).post('comments', comment_data)
])
