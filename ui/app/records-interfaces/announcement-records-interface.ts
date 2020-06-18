global.cobudgetApp.factory 'AnnouncementRecordsInterface', (config, BaseRecordsInterface, $q, AnnouncementModel) ->
  class AnnouncementRecordsInterface extends BaseRecordsInterface
    model: AnnouncementModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix

    seen: (params) ->
      @remote.post('seen', params)
