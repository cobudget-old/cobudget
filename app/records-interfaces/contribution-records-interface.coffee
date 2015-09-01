null 

### @ngInject ###
global.cobudgetApp.factory 'ContributionRecordsInterface', (config, BaseRecordsInterface, ContributionModel) -> 
  class ContributionRecordsInterface extends BaseRecordsInterface
    model: ContributionModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix 
