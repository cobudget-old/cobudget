module.exports = 
  url: '/groups/:groupId/drafts'
  template: require('./draft-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    window.scrollHeight = 0;
    console.log('this is the drafts page')
    return