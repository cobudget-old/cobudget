null

### @ngInject ###
global.cobudgetApp.factory 'Toast', ($mdToast, $location) ->
  new class Toast

    show: (msg) ->
      toast = $mdToast.simple()
        .content(msg)
      $mdToast.show(toast)

    showWithRedirect: (msg, path) ->
      toast = $mdToast.simple()
        .content(msg)
        .action('VIEW')
        .highlightAction(false)

      $mdToast.show(toast).then (res) ->
        if res == 'ok'
          $location.path(path)

    hide: ->
      jQuery('md-toast').hide()