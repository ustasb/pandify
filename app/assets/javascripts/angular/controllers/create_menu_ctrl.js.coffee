window.pandifyApp.controller 'CreateMenuCtrl', [
  '$scope',
  '$timeout',
  'pandifySession',
  'spotifyAuth',
  ($scope, $timeout, session, spotifyAuth) ->
    $scope.tracks = session.get('tracks') or []
    $scope.genreFilters = session.get('activeGenreFilters') or []
]
