### @ngInject ###

global.cobudgetApp.config (markedProvider) ->
  markedProvider.setRenderer
    link: (href, title, text) ->
      '<a href=\'' + href + '\'' + (if title then ' title=\'' + title + '\'' else '') + ' target=\'_blank\'>' + text + '</a>'
