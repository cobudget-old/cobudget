# app.config(['markedProvider', function (markedProvider) {
#   markedProvider.setRenderer({
#     link: function(href, title, text) {
#       return "<a href='" + href + "'" + (title ? " title='" + title + "'" : '') + " target='_blank'>" + text + "</a>";
#     }
#   });
# }]);


### @ngInject ###

global.cobudgetApp.config (markedProvider) ->
  markedProvider.setRenderer
    link: (href, title, text) ->
      "<a href='" + href + "'" + " target='_blank'>" + text + "</a>"
