### @ngInject ###

global.cobudgetApp.config (markedProvider) ->
  markedProvider.setRenderer
    link: (href, title, text) ->
      if href.startsWith('uid:')
        '<a href=\'#/users/' + href.replace('uid:','') + '\'' + ' target=\'_blank\'>' + text + '</a>'
      else
        '<a href=\'' + href + '\'' + (if title then ' title=\'' + title + '\'' else '') + ' target=\'_blank\'>' + text + '</a>'
