(function() {
  var module = angular.module('ngDownloadCsv', [])
  module.factory('DownloadCSV', ['$http', function ($http) {
    return function (params) {
      return $http({
        method: 'GET',
        url: params.url
      }).success(function (data, status, headers, config) {
        var anchor = angular.element('<a/>')
        anchor.attr({
          href: 'data:attachment/csv;charset=utf-8,' + encodeURI(data),
          target: '_blank',
          download: params.filename + '.csv'
        })[0].click()
      }).error(function (data, status, headers, config) {
        console.log('data: ', data)
      })
    }
  }])
}())
