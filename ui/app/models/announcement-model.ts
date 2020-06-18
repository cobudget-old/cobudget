null

### @ngInject ###
global.cobudgetApp.factory 'AnnouncementModel', (BaseModel) ->
  class AnnouncementModel extends BaseModel
    @singular: 'announcement'
    @plural: 'announcements'
    @indices: ['announcementId']
    @serializableAttributes: [
      'title',
      'body',
      'url',
      'userIds'
    ]

    relationships: ->
      @hasMany 'users'
