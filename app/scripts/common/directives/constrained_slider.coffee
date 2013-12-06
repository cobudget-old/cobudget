angular.module("directives.constrained_slider", [])
.directive "constrainedSlider", ($rootScope, ConstrainedSliderCollector) ->
  restrict: "EA"
  transclude: "false"
  template: "
    <slider min='{{min}}' max='{{max}}' orientation='{{orientation}}' ng-model='Model'></slider>
  "
  scope:
    Model: "=ngModel"
    allocatable: "=allocatable"
    affecting: "=affecting"
    orientation: "@orientation"
    percentageOf: "=percentageOf"
    max: "@max"
    min: "@min"
    identifier: "@identifier"
  link: (scope, element, attrs) ->
    slider_id = parseInt(scope.identifier)
    ConstrainedSliderCollector.sliders.push {id: slider_id, value: 0}
    console.log scope.percentageOf
    scope.$watch 'Model', (n, o)->
      if n != o
        collected_sliders = ConstrainedSliderCollector.sliders
        for s, i in collected_sliders
          if s.id == slider_id
            ConstrainedSliderCollector.sliders[i].value = n
        

        allocatable = parseInt(scope.max)
        console.log allocatable

        sum_of_other_sliders = ConstrainedSliderCollector.sumOtherSliders(collected_sliders, slider_id)
        console.log sum_of_other_sliders
        sum_of_sliders = ConstrainedSliderCollector.sumSliders(collected_sliders)
        console.log sum_of_sliders

        console.log n
        if n > (allocatable - sum_of_other_sliders)
          scope.Model = allocatable - sum_of_other_sliders
          scope.$apply()  unless $rootScope.$$phase
        else if sum_of_other_sliders > allocatable
          console.log "OVER"
          scope.Model = 0
          scope.$apply() unless $rootScope.$$phase
        else
          amount = ((n / 100) * scope.percentageOf).toFixed(2)
          new_item = {user_name: "Tony Soprano", amount: amount }
          item_identifier = new_item.user_name
          allocated = false
          for i in [0...scope.affecting.length]
            if item_identifier == scope.affecting[i].user_name
              allocated = true
              scope.affecting[i] = new_item
          if allocated == false
            scope.affecting.unshift new_item

