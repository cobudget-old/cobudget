null

### @ngInject ###
global.cobudgetApp.factory 'CommentModel', (BaseModel) ->
  class CommentModel extends BaseModel
    @singular: 'comment'
    @plural: 'comments'
    @indices: ['bucketId']
    @attributeNames = ['text', 'createdAt', 'updatedAt', 'userId', 'bucketId']