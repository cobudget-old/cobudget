null

### @ngInject ###
global.cobudgetApp.directive 'onlyDigits', () ->
  restrict: 'A'
  link: (scope, el, attrs) ->
    el.bind 'keypress', (e) ->
      unless _.includes(_.range(48, 57), e.keyCode)
        e.preventDefault()
