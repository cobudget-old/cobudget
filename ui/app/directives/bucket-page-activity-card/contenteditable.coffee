null

### @ngInject ###

global.cobudgetApp.directive 'contenteditable', ($sce) ->
      restrict: 'A'
      require: '?ngModel'
      link: (scope, element, attrs, ngModel) ->

        read = ->
          html = element.html()
          # When we clear the content editable the browser leaves a <br> behind
          # If strip-br attribute is provided then we strip this out
          if attrs.stripBr and html == '<br>'
            html = ''
          ngModel.$setViewValue html
          return

        if !ngModel
          return
        # do nothing if no ng-model
        # Specify how UI should be updated

        ngModel.$render = ->
          if ngModel.$viewValue != element.html()
            element.html $sce.getTrustedHtml(ngModel.$viewValue or '')
          return

        # Listen for change events to enable binding
        element.on 'blur keyup change', ->
          scope.$apply read
          return
        read()
        # initialize
        return
