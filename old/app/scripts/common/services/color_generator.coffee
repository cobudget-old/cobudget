myModule = angular.module("services.color_generator", [])
myModule.factory "ColorGenerator", ->
  obj = {}
  RGB2Color = (r, g, b) ->
    "#" + byte2Hex(r) + byte2Hex(g) + byte2Hex(b)

  byte2Hex = (n) ->
    nybHexString = "0123456789ABCDEF"
    String(nybHexString.substr((n >> 4) & 0x0F, 1)) + nybHexString.substr(n & 0x0F, 1)

  roundDecimal = (v, n) ->
    isNeg = v < 0
    v = Math.abs(v)
    ((if isNeg then "-" else "")) + String(Math.floor(v)) + "." + String((1 + Math.abs(v) - Math.floor(Math.abs(v))) * Math.pow(10, n)).substr(1, n)

  obj.makeColor = (frequency1, frequency2, frequency3, phase1, phase2, phase3, center, width, pos)->
    center = 200  if center is `undefined`
    width = 55  if width is `undefined`
    red = Math.sin(frequency1 * pos + phase1) * width + center
    grn = Math.sin(frequency2 * pos + phase2) * width + center
    blu = Math.sin(frequency3 * pos + phase3) * width + center
    RGB2Color red, grn, blu

  #use for fiddling with params
  obj.colorArray = ()->
    length = 60
    ary = []
    for i in [0..length]
      ary.push obj.makeColor(0.3,0.3,0.3,0,i * 1.25,4,177,65, i)
    ary
  obj
