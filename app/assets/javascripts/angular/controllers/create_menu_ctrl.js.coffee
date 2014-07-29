window.pandifyApp.controller 'CreateMenuCtrl', [
  '$scope',
  '$timeout',
  'pandifySession',
  'spotifyAuth',
  ($scope, $timeout, session, spotifyAuth) ->

    $scope.tracks = session.get('tracks') or []
    $scope.genreFilters = session.get('activeGenreFilters') or []

    setLoginTimeout = ->
      $timeout(
        -> $scope.loggedIn = false,
        spotifyAuth.getTimeUntilExpire()
      )

    $scope.logIn = -> spotifyAuth.openLoginWindow()
    $scope.loggedIn = !!spotifyAuth.getAccessToken()

    setLoginTimeout() if $scope.loggedIn

    $scope.$on 'spotifyLoggedIn', (event, data) ->
      spotifyAuth.setAccessToken(data.access_token, data.expires_in)

      $scope.$apply ->
        $scope.loggedIn = true
        setLoginTimeout()
]
