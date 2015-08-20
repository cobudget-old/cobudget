global.cobudgetApp.filter 'timeFromNowInWords', ->
  (date) ->
    moment(date).fromNow(true)

global.cobudgetApp.filter 'timeFromNowAmount', ->
  (date) ->
    moment(date).fromNow(true).split(' ')[0]

global.cobudgetApp.filter 'timeFromNowUnits', ->
  (date) ->
    moment(date).fromNow(true).split(' ')[1]

global.cobudgetApp.filter 'timeToNowAmount', ->
  (date) ->
    moment(date).toNow(true).split(' ')[0]

global.cobudgetApp.filter 'timeToNowUnits', ->
  (date) ->
    moment(date).toNow(true).split(' ')[1]

global.cobudgetApp.filter 'exactDateWithTime', ->
  (date) ->
    moment(date).format('dddd MMMM Do [at] h:mm a')
