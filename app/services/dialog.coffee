null

### @ngInject ###
global.cobudgetApp.factory 'Dialog', ($mdDialog) ->
  new class Dialog

    alert: (args = {}) ->
      alert = $mdDialog.alert
        title: args.title
        content: args.content
        ok: args.ok || 'ok'
      $mdDialog.show(alert)

    confirm: (args = {}) ->
      confirm = $mdDialog.confirm
        title: args.title
        content: args.content
        ok: args.ok || 'ok'
        cancel: args.cancel || 'cancel'
      $mdDialog.show(confirm)

    custom: (args = {}) ->
      defaults =
        clickOutsideToClose: true
        preserveScope: true
      custom = _.merge(defaults, args)
      $mdDialog.show(custom)

    close: ->
      $mdDialog.cancel()
