angular.module('cobudget')
  .directive 'contributionStatus', ->

    statusFn = (scope, element, attrs) ->

      originalColor = element.css("color")

      scope.$watch attrs.contributionStatus, (contributionStatus) ->
        if (contributionStatus == 'warning')
          element.removeClass('complete')
          element.addClass('warning')
        else if (contributionStatus == 'complete')
          element.removeClass('warning')
          element.addClass('complete')
        else
          element.removeClass('complete')
          element.removeClass('warning')

    return {
        restrict: 'EA',
        link: statusFn
    };
