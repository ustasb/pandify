window.pandifyApp.controller 'CreateMenuCtrl', [
  '$scope',
  'pandifySession',
  'spotifyAuth',
  ($scope, session, spotifyAuth) ->

    $scope.logIn = -> spotifyAuth.logIn()

    $scope.tracks = session.get('tracks') or []
    $scope.genreFilters = session.get('activeGenreFilters') or []
]
