trackUriWell = ($window, $timeout) ->
  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/track_uri_well.html'
  scope: false
  link: ($scope, element, attrs) ->
    w = $($window)
    marginBottom = 50

    onResize = ->
      offsetTop = element.offset().top
      height = w.height() - offsetTop - marginBottom
      element.height(height)

    w.resize(onResize)
    $timeout(onResize, 0) # Execute when loaded into the DOM.

trackUriWell.$inject = ['$window', '$timeout']
angular.module('pandify').directive('trackUriWell', trackUriWell)
