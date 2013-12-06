myModule = angular.module("services.constrained_slider_collector", [])
myModule.factory "ConstrainedSliderCollector", ->
  obj = {}
  obj.sliders = []
  obj.sumSliders = (sliders)->
    sum = 0
    for s in sliders
      sum += s.value
    sum
  obj.sumOtherSliders = (sliders, exclude_id)->
    console.log sliders
    sum = 0
    for s in sliders
      unless s.id == exclude_id
        sum += s.value
    sum
  obj
