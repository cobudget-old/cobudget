null

### @ngInject ###
global.cobudgetApp.directive 'landingPageToolbar', () ->
    restrict: 'E'
    template: require('./landing-page-toolbar.html')
    replace: true
    controller: ($location, $scope, $anchorScroll, Dialog) ->

      $scope.createGroupDialog = (membership) ->
        createGroupDialog = require('./../../components/create-group-dialog/create-group-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(createGroupDialog)

      $scope.scrollTo = (id) ->
        $location.hash(id)
        $anchorScroll()

      $scope.redirectToLoginPage = ->
        $location.path('/login')

      $scope.redirectToHomePage = ->
        $location.path('/')

      $scope.redirectToHomePageCreateGroup = ->
        $location.path('/')
        $location.hash('createGroup')

      $scope.redirectToHomePageTour = ->
        $location.path('/')
        $location.hash('tour')

      $scope.redirectToHomePageStudies = ->
        $location.path('/')
        $location.hash('studies')

      $scope.redirectToHomePagePricing = ->
        $location.path('/')
        $location.hash('pricing')

      $scope.redirectToCaseStudiesPage = ->
        $location.path('/case-studies')

      $scope.redirectToServicesPage = ->
        $location.hash('')
        $location.path('/services')

      $scope.redirectToAboutPage = ->
        $location.path('/about')

      return
