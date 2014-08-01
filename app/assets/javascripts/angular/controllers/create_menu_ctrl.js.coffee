window.pandifyApp.controller 'CreateMenuCtrl', [
  '$scope',
  '$timeout',
  'pandifySession',
  'spotifyAuth',
  ($scope, $timeout, session, spotifyAuth) ->

    setLoginTimeout = ->
      $timeout(
        -> $scope.loggedIn = false,
        spotifyAuth.getTimeUntilExpire()
      )

    $scope.createPlaylist = ->
      spotifyApi = new SpotifyWebApi()
      spotifyApi.setAccessToken(spotifyAuth.getAccessToken())
      spotifyAuth.uploadTracks(
        spotifyApi,
        $scope.playlistName,
        $scope.tracks.map (track) -> track.uri
      )

    $scope.tracks = session.get('tracks') or []
    $scope.genreFilters = session.get('activeGenreFilters') or []

    $scope.logIn = -> spotifyAuth.openLoginWindow()
    $scope.loggedIn = !!spotifyAuth.getAccessToken()

    setLoginTimeout() if $scope.loggedIn

    $scope.$on 'spotifyLoggedIn', (event, data) ->
      spotifyAuth.setAccessToken(data.access_token, data.expires_in)

      $scope.$apply ->
        $scope.loggedIn = true
        setLoginTimeout()
]
