module.exports = 
  url: '/email_settings'
  template: require('./email-settings-page.html')
  controller: ($scope) ->

    $scope.settings = [
      {
        header: "Daily summary email.", 
        description: "Each day, send an email with yesterday's unread activity in every group that you're part of."
      },
      {
        header: "Activity in buckets I've created.", 
        description: "When you create a bucket, you are subscribed to all activity on that bucket."
      },
      {
        header: "Activity in buckets I participate in.", 
        description: "When you participate in a bucket, you will get all activity from that bucket mailed to you."
      }
    ]

    $scope.cancel = ->
      console.log('cancel clicked')

    $scope.done = ->
      console.log('done clicked')

    return