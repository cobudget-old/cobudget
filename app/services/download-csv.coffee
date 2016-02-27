null

### @ngInject ###
global.cobudgetApp.factory 'DownloadCSV', ($http) ->
  (params) ->
    console.log('params: ', params)
    $http({method: 'GET', url: params.url})
      .success (data, status, headers, config) ->
        anchor = angular.element('<a/>')
        anchor.attr({
          href: 'data:attachment/csv;charset=utf-8,' + encodeURI(data),
          target: '_blank',
          download: "#{params.filename}.csv"
        })[0].click()
      .error (data, status, headers, config) ->
        console.log('data: ', data)
