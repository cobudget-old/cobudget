angular.module("directives.slider", [])
.directive "slider", ($rootScope) ->
  restrict: "EA"
  transclude: "false"
  template: "<div class='slider'></div>"
  replace: true
  scope:
    Model: "=ngModel"

  link: (scope, element, attrs) ->
    change = ->
      scope.Model = parseInt(element.val(), 10)
      scope.$apply()  unless $rootScope.$$phase

    element.noUiSlider
      range: [parseInt(attrs.min, 10), parseInt(attrs.max, 10)]
      start: 1
      handles: 1
      step: 1.0
      set: ()->
        change()


    #element.slider
      #value: scope.Model
      #animate: attrs.animate
      #orientation: attrs.orientation
      #min: parseInt(attrs.min, 10)
      #max: parseInt(attrs.max, 10)
      #slide: change
      #change: change

    scope.$watch "Model", (value) ->
      element.val parseInt(value, 10)

