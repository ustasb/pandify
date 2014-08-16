window.pandifyApp.directive 'trackTable', ->

  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/track_table.html'
  scope:
    tracks: '='

  controller: ['$scope', ($scope) ->
    $scope.imgScale = 1 / 3
  ]

  link: ($scope, element, attrs) ->

    element.on 'mouseenter', '.track', (e) ->
      row = $(e.currentTarget)

      row.addClass('hovered')

      albumArt = row.find('.album-art')
      albumArt.css
        # Vertically center the image.
        top: - (albumArt.height() - row.height()) / 2

    element.on 'mouseleave', '.track', (e) ->
      $(e.currentTarget).removeClass('hovered')
