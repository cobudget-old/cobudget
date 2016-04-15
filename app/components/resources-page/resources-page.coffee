module.exports =
  url: '/resources'
  template: require('./resources-page.html')
  controller: ($scope) ->

    $scope.articles = [
      {
        title: "Getting started with collaborative funding.",
        description: "A basic guide on using cobudget in your team, group, or community.",
        articleUrl: "https://medium.com/@Cobudget/getting-started-with-collaborative-funding-265dabef30e3#.n9evseijx",
        imgUrl: "http://i.imgur.com/zd7n4QX.png"
      }
    ]

    return
