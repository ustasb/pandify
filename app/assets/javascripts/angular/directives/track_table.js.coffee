TrackTableLink = ($scope, element, attrs) ->
  element.on 'mouseenter', '.track', (e) ->
    row = $(e.currentTarget)

    row.addClass('hovered')

    albumArt = row.find('.album-art')
    albumArt.css
      # Vertically center the image.
      top: - (albumArt.height() - row.height()) / 2

  element.on 'mouseleave', '.track', (e) ->
    $(e.currentTarget).removeClass('hovered')

TrackTableCtrl = ($scope) ->
  $scope.IMG_SCALE = 1 / 3

trackTable = ->
  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/track_table.html'
  scope:
    tracks: '='
  link: TrackTableLink
  controller: TrackTableCtrl

TrackTableCtrl.$inject = ['$scope']
angular.module('pandify').directive('trackTable', trackTable)
