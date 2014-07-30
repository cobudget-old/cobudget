angular.module("directives.constrained_slider", [])
.directive "constrainedSlider", ['$rootScope', 'flash', 'ConstrainedSliderCollector', 'User', 'Allocation', ($rootScope, flash, ConstrainedSliderCollector, User, Allocation) ->
  restrict: "EA"
  transclude: "false"
  template: "<div class='slider'></div>"
  scope:
    #used like a buffer, is the user_allocation, not updated till after save
    bucket_allocation: "=bucketAllocation"
    affecting: "=affecting"
    allocatable: "=allocatable"
    allocated: "=allocated"
    min: "=min"
    identifier: "@identifier"
    color: "@color"

  link: (scope, element, attrs) ->
    scope.slider_id = parseFloat(scope.identifier)

    el = angular.element element.children()[0]
    el.noUiSlider
      range: [parseInt(attrs.min, 10), scope.allocatable]
      start: scope.bucket_allocation
      handles: 1
      step: 1.0
      direction: 'ltr'
      orientation: 'horizontal'
      set: ()->
        change()
        return

    scope.allocationAmount = (o, n)->
      o_constrained = constrainValue(o)
      if o > 0
        amt = o - n
        if o > n
          if o > o_constrained
            amt = o_constrained
          else
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
      alc.amount = (amt / 100).toFixed(2)
      if alc.amount != parseFloat(0).toFixed(2)
        Allocation.createAllocation(alc).then (success)->
          $rootScope.processing = false
          $rootScope.$broadcast('current-user-bucket-allocation-update', {bucket_id: parseFloat(scope.identifier)})
        , (error)->
          console.log error

    saveValue = (new_value)->
      amount = new_value
      new_item = {bucket_id: parseFloat(scope.identifier), user_id: User.getCurrentUser().id, user_name_or_email: User.getUserNameOrEmail(), user_color: User.getCurrentUser().bg_color, new_item: true, amount: amount, bucket_color: scope.color}
      item_identifier = new_item.user_id
      allocated = false
      for item, i in scope.affecting
        if item_identifier == scope.affecting[i].user_id
          allocated = true
          scope.affecting[i] = new_item

      old_val = el.val()
      scope.saveAllocation(scope.allocationAmount(scope.bucket_allocation, new_value), new_item)
       
    constrainValue = (incoming_value)->
      allocated = scope.allocated
      allocated_excluding_this_bucket = allocated - scope.bucket_allocation
      allocatable = scope.allocatable

      new_value = incoming_value
      if new_value + allocated_excluding_this_bucket > allocatable
        new_value = allocatable - allocated_excluding_this_bucket
        if incoming_value < new_value
          new_value = incoming_value
      new_value

    change = ->
      if $rootScope.processing
        flash('error', "Still processing your last allocation, try again now...", 2000)
        el.val scope.bucket_allocation
        $rootScope.processing = false
        return false
      else
        $rootScope.processing = true
        n = parseFloat(el.val())

        value = constrainValue(n)
        saveValue(value)

        #these should probably go in the save block so it only updates view if saved
        el.val value
        scope.bucket_allocation = value

        scope.$apply() unless $rootScope.$$phase
]
