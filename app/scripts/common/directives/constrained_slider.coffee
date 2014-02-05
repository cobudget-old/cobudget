angular.module("directives.constrained_slider", [])
.directive "constrainedSlider", ['$rootScope', 'ConstrainedSliderCollector', 'User', 'Allocation', ($rootScope, ConstrainedSliderCollector, User, Allocation) ->
  restrict: "EA"
  transclude: "false"
  template: "<div class='slider'></div>"
  scope:
    Model: "=ngModel"
    affecting: "=affecting"
    orientation: "@orientation"
    percentageOf: "@percentageOf"
    secondMax: "@secondMax"
    max: "@max"
    min: "=min"
    identifier: "@identifier"
    color: "@color"

  link: (scope, element, attrs) ->
    scope.slider_id = parseInt(scope.identifier, 10)
    hit = false
    for slider, i in ConstrainedSliderCollector.sliders
      if slider.id == scope.slider_id 
        hit = true
    unless hit == true
      ConstrainedSliderCollector.sliders.push {id: scope.slider_id, value: 0}

    el = angular.element element.children()[0]
    el.noUiSlider
      range: [parseInt(attrs.min, 10), parseInt(scope.max, 10)]
      start: 0
      handles: 1
      step: 1.0
      direction: 'ltr'
      orientation: attrs.orientation
      set: ()->
        change()

    scope.allocationAmount = (o, n)->
      if o > 0
        amt = o - n
        if o > n
          amt = (o - n) * -1 
        else
          amt = (n - o)
      else
        amt = n 

    scope.saveAllocation = (amt, new_item)->
      alc = {}
      alc.admin_id = 1
      alc.user_id = new_item.user_id
      alc.bucket_id = new_item.bucket_id
      alc.amount = amt / 100
      console.log "Saving", alc
      Allocation.createAllocation(alc).then (success)->
        console.log "Allocation Created:", alc
      , (error)->
        console.log error

    scope.$watch "Model", (n, o) ->
      save = false
      scope.collected_sliders = ConstrainedSliderCollector.sliders
      for s, i in scope.collected_sliders
        if s.id == scope.slider_id
          scope.collected_sliders[i].value = n

      amount = scope.Model
      new_item = {bucket_id: parseInt(scope.identifier, 10), user_id: User.getCurrentUser().id, user_color: User.getCurrentUser().bg_color, new_item: true, amount: amount, bucket_color: scope.color}
      item_identifier = new_item.user_id
      allocated = false
      for item, i in scope.affecting
        if item_identifier == scope.affecting[i].user_id
          allocated = true
          scope.affecting[i] = new_item
      #hammy as making sure it doesn't save the initial load of data
      if parseFloat(o) > 0 and parseFloat(n) == 0
        save = true
      else if parseFloat(el.val()) == 0.00 
        save = false
      else if parseFloat(el.val()) == parseFloat(o)
        save = false
      else if parseFloat(el.val()) > 0 
        if parseFloat(n) > 0
          save = true
      val = constrainValue(scope.Model)
      scope.Model = val
      el.val val
      if save == true
        scope.saveAllocation(scope.allocationAmount(o, val), new_item)

    getAffectingTotal = ->
      total = 0
      for item, i in scope.affecting
        unless item.user_id == User.getCurrentUser().id
          total += item.amount
      total

    constrainValue = (incoming_value)->
      user_max_assignable = parseFloat(scope.max)
      affected_max_assignable = parseFloat(scope.secondMax)

      user_already_assigned = ConstrainedSliderCollector.sumOtherSliders(scope.collected_sliders, scope.slider_id)
      new_value = incoming_value
      if new_value + user_already_assigned > user_max_assignable
        new_value = user_max_assignable - user_already_assigned
        if incoming_value < new_value
          new_value = incoming_value
      new_value

    change = ->
      n = parseFloat(el.val())

      value = constrainValue(n)
      el.val value
      scope.Model = value
      scope.$apply() unless $rootScope.$$phase
]
