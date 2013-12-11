angular.module("directives.vert_graph", [])
.directive "vertGraph", ['$rootScope', ($rootScope) ->
  restrict: "EA"
  transclude: "false"
  template: "
    <div class='m-vert-graph'>
      <div ng-repeat='item in items track by $index' class='m-vert-graph__item'>
        <small>${{item.amount}}</small>
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

    scope.$watch "items", (n, o) ->
      for item, i in n
        value = item.amount * 1000
        percent_of_total = value / (scope.max * 1000) * 100
        px = parseInt(attrs.height) * (percent_of_total / 100)

        counter = scope.items.length - i

        color_el = angular.element element.children()[counter - 1]
        el = angular.element element.children()[i]

        bgColor = makeColor(.3,.3,.3,0,i*2,4,180,65, i)
        if px < 16
          el.children('small').css
            opacity: 0
        else
          el.children('small').css
            opacity: 1
        el.css
          height: px 
        color_el.css
          backgroundColor: bgColor
    , true
]
