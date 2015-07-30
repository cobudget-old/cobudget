module.exports = 
  url: '/'
  template: require('app/components/welcome-page/welcome-page.html')
  controller: ($scope, $auth, Records, $http) ->
    console.log('this is the welcome page controller')

    $auth.submitLogin({email: 'admin@example.com', password: 'password'})
      .then (res) ->
        console.log("success: ", res)
        Records.groups.fetch({})
      .catch (err) ->
        console.error("error: ", err)