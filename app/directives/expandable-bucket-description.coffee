null

### @ngInject ###
global.cobudgetApp.directive 'expandableBucketDescription', ($timeout) ->
  link: (scope, element, attr) ->

    doShit = ->
      height = element[0].offsetHeight
      if height == 200
        console.log('overflow')
        element.css('overflow', 'hidden')
      else
        console.log('no overflow')
      scope.height = height

    $timeout(doShit)
