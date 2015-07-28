module.exports = 
  url: '/groups'
  template: require('app/components/groups-page/groups-page.html')
  controller: ($scope, Records) ->
    console.log(Records.groups.fetch({}))