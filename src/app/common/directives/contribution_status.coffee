angular.module('cobudget')
  .directive 'contributionStatus', ->

    statusFn = (scope, element, attrs) ->

      originalColor = element.css("color")

      scope.$watch attrs.contributionStatus, (contributionStatus) ->
        if (contributionStatus == 'warning')
          element.addClass('warning')
        else
          element.removeClass('warning')
    
    return {
        restrict: 'EA',
        link: statusFn
    };