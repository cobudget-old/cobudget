### @ngInject ###

global.cobudgetApp.config (markedProvider) ->
  markedProvider.setRenderer
    link: (href, text) ->
      "<a href='" + href + "'" + " target='_blank'>" + text + "</a>"
