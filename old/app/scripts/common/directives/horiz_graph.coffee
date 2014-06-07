angular.module("directives.horiz_graph", [])
.directive "horizGraph", ['$rootScope', ($rootScope)->
  restrict: "EA"
  transclude: "false"
  template: "
    <div class='m-horiz-graph'>
      <div class='m-horiz-graph_max-mark' style='left: {{max_pos}}%; width: {{max_reached_width}}%;'>
        <small>Over Max</small>
      </div>
      <div class='m-horiz-graph_items'>
        <div ng-repeat='item in items track by $index'  class='m-horiz-graph_item'>
          <small ng-show='item.amount > 0'>${{item.amount / 100}}</small>
        </div>
      </div>
    </div>
  "
  scope:
    items: "=items"
    max: "=max"
    bucket_id: "@bucketId"
  replace: true
  link: (scope, element, attrs) ->
    getPercentage = (item, items)->
      value = item.amount
      total = _.reduce(items, (result, item)->
        result += parseFloat(item.amount)
        result
      , 0)
      if total > scope.max
        scope.max_reached = true
        scope.max_pos = (scope.max / total) * 100 
        scope.max_reached_width = 100 - ((scope.max / total) * 100)
        total_for_percent = total
      else
        scope.max_reached = false
        total_for_percent = scope.max
        scope.max_pos = 0
      percent_of_total = (value / total_for_percent) * 100
      pc = percent_of_total

    scope.updateGraph = (items)->
      angular.forEach items, (item, i)->
        pc = getPercentage(item, items)

        el = angular.element angular.element(element.children()[1]).children()[i]

        if pc < 8
          el.children('small').css
            opacity: 0
        else
          el.children('small').css
            opacity: 1
        if scope.max_reached
          element.addClass('js-show-max-mark')
        else
          element.removeClass('js-show-max-mark')
        el.css
          width: pc + "%" 
          backgroundColor: item.user_color

    scope.$on "bucket-allocations-updated", (event, data)->
      if parseFloat(scope.bucket_id) == data.bucket_id
        scope.updateGraph(data.bucket_allocations)
]
