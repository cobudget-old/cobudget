angular.module("directives.expander", [])
.directive('dExpander', [() ->
  restrict: 'A'
  link: (scope, element, attr)->
    expander_button = angular.element(element[0].querySelector('.utl-expander-button'))
    expander_indicator = angular.element(element[0].querySelector('.utl-expander-indicator'))
    expander_button.on "click", (e)->
      element.toggleClass("j-expanded")
      expander_indicator.toggleClass("j-active")
      #if element.hasClass("j-expanded")
        #expander_button.text("less...")
      #else
        #expander_button.text("more...")
        #element.append(expander_button)
])
