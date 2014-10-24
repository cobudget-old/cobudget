`// @ngInject`
angular.module('cobudget').factory 'BucketModel',  (ContributionModel) ->
  class BucketModel
    constructor: (data = {}) ->
      @id = data.id
      @name = data.name
      @description = data.description
      @percentageFunded = data.percentage_funded
      @contributionTotalCents = data.contribution_total_cents
      @targetCents = data.target_cents
      @contributions = _.map data.contributions, (contribution) ->
        # attach bucket_id to contribution, as the data
        # returned from the API does not have this
        contrib = _.extend(_.clone(contribution), bucket_id: data.id)
        new ContributionModel(contrib)