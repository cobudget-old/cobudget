null

### @ngInject ###

global.cobudgetApp.factory 'DownloadCSV', ($http) ->
    (params) ->
      $http(
        method: 'GET'
        url: params.url).then (response) ->
        anchor = angular.element('<a/>')
        angular.element(document.body).append anchor
        anchor.attr(
          href: 'data:attachment/csv;charset=utf-8,' + encodeURI(response.data)
          target: '_self'
          download: params.filename + '.csv')[0].click()
        anchor.remove()
