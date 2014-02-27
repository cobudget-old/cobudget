angular.module("directives.comments", [])
.directive('comments', ['$rootScope', 'User', 'Comment', 'Time', ($rootScope, User, Comment, Time) ->
  restrict: 'A'
  templateUrl: '/views/directives/comments.html'
  scope:
    container: '=container'
    comment_count: '=commentCount'
  link: (scope, element, attr)->
    scope.comments = []
    scope.ux ={}
    scope.ux.reply_form_for = undefined
    scope._comment = {}
    scope._reply = {}
    scope.comment_count = 0

    scope.formatCommentTimes = (comment)->
      comment.created_at_ago = Time.ago(comment.created_at)
      comment

    scope.calculateCommentCount = ->
      count = 0
      for comment in scope.comments
        count++
        for child in comment.children
          count++
      scope.comment_count = count

    Comment.commentsByBucket(scope.container.id).then (comments)->
      for comment in comments
        comment = scope.formatCommentTimes(comment)
        for child in comment.children
          child = scope.formatCommentTimes(child)
      scope.comments = comments
      console.log scope.comments
      scope.calculateCommentCount()
    , (error)->
      console.log error

    scope.create = ->
      unless scope._comment.body?
        console.log "no body TODO error"
        return false
      Comment.createComment(scope.container.id, scope._comment).then (comment)->
        scope.comments.push scope.formatCommentTimes(comment)
        scope._comment = {}
      , (error)->
        console.log error

    scope.createReply = (comment)->
      scope._reply.comment_id = comment.id
      unless scope._reply.body?
        console.log "no body TODO error"
        return false
      Comment.createComment(scope.container.id, scope._reply).then (new_comment)->
        comment.children.push scope.formatCommentTimes(new_comment)
        scope._reply = {}
      , (error)->
        console.log error

    scope.commentClasses = (comment)->
      classes = []
      classes.push 'from-sponsor' if comment.user.id == scope.container.sponsor_id
      classes.push 'from-self' if comment.user.id == User.getCurrentUser().id
      classes

    scope.toggleReplyFormFor = (comment)->
      if scope.ux.reply_form_for != undefined
        scope.ux.reply_form_for = undefined
      else
        scope.ux.reply_form_for = comment.id

    $rootScope.channel.bind('comment_created', (response) ->
      if response.comment.user.id == User.getCurrentUser().id
        return false
      if response.bucket_id == scope.container.id
        console.log response.parent_id
        if response.parent_id != null
          for comment in scope.comments
            if response.parent_id == comment.id
              scope.$apply ()->
                comment.children.push scope.formatCommentTimes(response.comment)
                scope.calculateCommentCount()
              break
        else
          console.log "WHT HERE"
          scope.$apply ()->
            scope.comments.push scope.formatCommentTimes(response.comment)
            scope.calculateCommentCount()
      else
        return false
    )
])
