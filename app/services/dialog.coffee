null

### @ngInject ###
global.cobudgetApp.factory 'Dialog', ($mdDialog) ->
  new class Dialog

    alert: (args) ->
      alert = $mdDialog.alert
        title: args.title
        content: args.content
        ok: args.buttonText || 'close'
      $mdDialog.show(alert)

    prompt: ->
