angular.module("directives.happened_after_marker", [])
.directive "happenedAfterMarker", ['$timeout', 'Time', 'User', ($timeout, Time, User) ->
  restrict: "EA"
  scope:
    item: '=item'
    date: '=date'
    last: '=last'
  link: (scope, element, attrs) ->
    html = "<div class='o-happened-after-last-sign-in'>
      <span class='o-up-arrow'></span><small class='pull-right'>new to you</small>
      </div>"
    #TODO for each set, maybe move to directive
    getIfAfterLastSignIn = (date)->
      signed_in = User.getCurrentUser().last_sign_in_at
      Time.happenedAfter(date, signed_in)

    if getIfAfterLastSignIn(scope.date)
      element.addClass('j-happened-after-last-sign-in')

    if scope.last
      $timeout ()->
        $(element.parent().parent()).find('.j-happened-after-last-sign-in').last().after(html)
]
