autoFocus = ($timeout) ->
  restrict: 'A'
  link: ($scope, element, attrs) ->
    focusOnElement = -> element.focus()
    $timeout(focusOnElement, 0)

autoFocus.$inject = ['$timeout']
angular.module('pandify').directive('autoFocus', autoFocus)
