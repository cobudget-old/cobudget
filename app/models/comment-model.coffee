null

### @ngInject ###
global.cobudgetApp.factory 'CommentModel', (BaseModel) ->
  class CommentModel extends BaseModel
    @singular: 'comment'
    @plural: 'comments'
    @indices: ['bucketId', 'userId']
    @serializableAttributes: ['bucketId', 'body']

    relationships: ->
      @belongsTo 'author', from: 'users', by: 'userId'
      @belongsTo 'bucket'

    authorName: ->
      if @author().isMemberOf(@bucket().group())
        @author().name
      else
        "[deleted user]"