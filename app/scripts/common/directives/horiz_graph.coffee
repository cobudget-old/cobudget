angular.module("directives.horiz_graph", [])
.directive "horizGraph", ['$rootScope', ($rootScope) ->
  restrict: "EA"
  transclude: "false"
  template: "
    <div class='m-horiz-graph'>
      <div class='m-horiz-graph_max-mark' style='left: {{max_pos}}%; width: {{max_reached_width}}%;'>Over Max</div>
      <div class='m-horiz-graph_items'>
        <div ng-repeat='item in items track by $index' class='m-horiz-graph_item'>
          <small>${{item.amount}}</small>
        </div>
      </div>
    </div>
  "
  scope:
    items: "=items"
    max: "=max"
  replace: true
  link: (scope, element, attrs) ->
    RGB2Color = (r, g, b) ->
      "#" + byte2Hex(r) + byte2Hex(g) + byte2Hex(b)

    byte2Hex = (n) ->
      nybHexString = "0123456789ABCDEF"
      String(nybHexString.substr((n >> 4) & 0x0F, 1)) + nybHexString.substr(n & 0x0F, 1)

    roundDecimal = (v, n) ->
      isNeg = v < 0
      v = Math.abs(v)
      ((if isNeg then "-" else "")) + String(Math.floor(v)) + "." + String((1 + Math.abs(v) - Math.floor(Math.abs(v))) * Math.pow(10, n)).substr(1, n)

    makeColor = (frequency1, frequency2, frequency3, phase1, phase2, phase3, center, width, pos)->
      center = 200  if center is `undefined`
      width = 55  if width is `undefined`
      red = Math.sin(frequency1 * pos + phase1) * width + center
      grn = Math.sin(frequency2 * pos + phase2) * width + center
      blu = Math.sin(frequency3 * pos + phase3) * width + center
      RGB2Color red, grn, blu

    getPercentage = (item)->
      value = item.amount
      total = _.reduce(scope.items, (result, item)->
        result += parseInt(item.amount, 10)
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

    scope.$watch "items", (n, o) ->
      for item, i in n
        pc = getPercentage(item)

        counter = scope.items.length - i

        #color_el = angular.element angular.element(element.children()[1]).children()[counter - 1]
        el = angular.element angular.element(element.children()[1]).children()[i]

        bgColor = makeColor(.3,.3,.3,0,i*2,4,180,65, i)
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
    , true
]
