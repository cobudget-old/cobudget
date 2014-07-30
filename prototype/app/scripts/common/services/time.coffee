angular.module("services.time", [])
.factory "Time", ['User', (User)->
  full: (time)->
    moment.tz(time, User.getCurrentUser().timezone).format('MMMM Do YYYY')
  ago: (time)->
    moment.tz(time, User.getCurrentUser().timezone).fromNow()
  happenedAfter: (first_time, second_time)->
    moment(first_time).isAfter(second_time)
]

