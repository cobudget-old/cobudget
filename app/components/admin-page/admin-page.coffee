module.exports = 
  url: '/admin'
  template: require('./admin-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope) ->
    
    return