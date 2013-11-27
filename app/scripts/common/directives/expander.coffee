angular.module("directives.expander", [])
.directive('dExpander', [() ->
  restrict: 'A'
  link: (scope, element, attr)->
    expander_button = angular.element("<div class='utl-expander-btn text-center'>more...</div>")
    expander_button.css
    expander_button.on "click", (e)->
      element.toggleClass("j-expanded")
      if element.hasClass("j-expanded")
        expander_button.text("less...")
      else
        expander_button.text("more...")
    element.append(expander_button)
])
