angular.module("directives.constrained_slider", [])
.directive "constrainedSlider", ['$rootScope', 'ConstrainedSliderCollector', ($rootScope, ConstrainedSliderCollector) ->
  restrict: "EA"
  transclude: "false"
  template: "<div class='slider'></div>"
  scope:
    Model: "=ngModel"
    allocatable: "=allocatable"
    affecting: "=affecting"
    orientation: "@orientation"
    percentageOf: "=percentageOf"
    secondMax: "@secondMax"
    max: "=max"
    min: "@min"
    identifier: "@identifier"
    color: "@color"

  link: (scope, element, attrs) ->

    scope.slider_id = parseInt(scope.identifier)
    ConstrainedSliderCollector.sliders.push {id: scope.slider_id, value: 0}

    el = angular.element element.children()[0]
    el.noUiSlider
      range: [parseInt(attrs.min, 10), parseInt(scope.max, 10)]
      start: 1
      handles: 1
      step: 1.0
      direction: 'ltr'
      orientation: attrs.orientation
      set: ()->
        change()

    scope.$watch "Model", (n, o) ->
      scope.collected_sliders = ConstrainedSliderCollector.sliders
      for s, i in scope.collected_sliders
        if s.id == scope.slider_id
          ConstrainedSliderCollector.sliders[i].value = n

      amount = scope.Model
      new_item = {bucket_id: parseInt(scope.identifier, 10), user_id: $rootScope.current_user.id, user_color: "#63C3E0", amount: amount, is_new: true, bucket_color: scope.color}
      item_identifier = new_item.user_id
      allocated = false
      for item, i in scope.affecting
        if item_identifier == scope.affecting[i].user_id
          allocated = true
          scope.affecting[i] = new_item
      if allocated == false
        scope.affecting.push new_item
      el.val scope.Model

    getAffectingTotal = ->
      total = 0
      for item, i in scope.affecting
        unless item.user_id == $rootScope.current_user.id
          total += item.amount
      total

    constrainValue = (incoming_value)->
      user_max_assignable = parseInt(scope.max, 10)
      affected_max_assignable = parseInt(scope.secondMax, 10)

      user_already_assigned = ConstrainedSliderCollector.sumOtherSliders(scope.collected_sliders, scope.slider_id)

      #slider_total_already_assigned = getAffectingTotal()

      #slider_left_to_be_assigned = affected_max_assignable - slider_total_already_assigned

      #if incoming_value > slider_left_to_be_assigned
        #if incoming_value + slider_left_to_be_assigned > slider_left_to_be_assigned
          #new_value = slider_left_to_be_assigned
        #else
          #new_value = incoming_value
      #else 
        #new_value = incoming_value

      new_value = incoming_value
      if new_value + user_already_assigned > user_max_assignable
        new_value = user_max_assignable - user_already_assigned
        if incoming_value < new_value
          new_value = incoming_value
      new_value

    change = ->
      n = parseInt(el.val(), 10)

      value = constrainValue(n)
      el.val value
      scope.Model = value
      scope.$apply() unless $rootScope.$$phase
]
