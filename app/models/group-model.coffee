null

# @ngInject
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'

    setupViews: ->
      @setupView 'buckets', 'createdAt', true # has_many ___, order, up/down

    buckets: ->
      @bucketsView.data()