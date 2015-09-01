null

### @ngInject ###
global.cobudgetApp.factory 'ContributionModel', (BaseModel) ->
  class ContributionModel extends BaseModel
    @singular: 'contribution'
    @plural: 'contributions'
    @indices: ['bucketId', 'userId']
    @serializableAttributes: ['amount']

    relationships: ->
      @belongsTo 'bucket'
      @belongsTo 'user'