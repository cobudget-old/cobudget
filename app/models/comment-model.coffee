null

### @ngInject ###
global.cobudgetApp.factory 'CommentModel', (BaseModel) ->
  class CommentModel extends BaseModel
    @singular: 'comment'
    @plural: 'comments'
    @indices: ['bucketId', 'userId']
    # @attributeNames = ['text', 'createdAt', 'updatedAt', 'userId', 'bucketId']
    @serializableAttributes: ['bucketId', 'text']

    relationships: ->
      @belongsTo 'author', from: 'users', by: 'userId'
      @belongsTo 'bucket'