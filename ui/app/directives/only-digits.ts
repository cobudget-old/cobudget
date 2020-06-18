null

### @ngInject ###
global.cobudgetApp.directive 'onlyDigits', () ->
  restrict: 'A'
  link: (scope, el, attrs) ->
    el.bind 'keypress', (e) ->
      acceptableKeyCodes = _.range(48,58).concat([0, 8])
      unless _.includes(acceptableKeyCodes, e.which)
        e.preventDefault()
