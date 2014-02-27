angular.module("directives.tab_switcher", [])
.directive('tabSwitcher', [() ->
  restrict: 'A'
  link: (scope, element, attr)->
    $(element).find('.tab-nav-item').on 'click', (e)->
      $(element).find('.tab-nav-item').removeClass('tab-nav-active') 
      $(@).addClass('tab-nav-active')
      $(element).find('.tab').removeClass('tab-active')
      target = '#tab-' + $(@).attr('id').split('-')[1].toLowerCase()
      $(element).find(target).addClass('tab-active')

])
