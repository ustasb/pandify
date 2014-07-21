window.pandifyApp.controller 'CreateMenuCtrl', [
  '$scope',
  'pandifySession',
  ($scope, session) ->

    $scope.tracks = session.get('tracks') or []
    $scope.genreFilters = session.get('activeGenreFilters') or []
]
