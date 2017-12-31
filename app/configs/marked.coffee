### @ngInject ###

global.cobudgetApp.config (markedProvider) ->
  markedProvider.setRenderer
    link: (href, title, text) ->
      if href.startsWith('/users')
        '<a href=\'#' + href + '\'' + ' target=\'_blank\'>' + text + '</a>'
      else
        '<a href=\'' + href + '\'' + (if title then ' title=\'' + title + '\'' else '') + ' target=\'_blank\'>' + text + '</a>'
