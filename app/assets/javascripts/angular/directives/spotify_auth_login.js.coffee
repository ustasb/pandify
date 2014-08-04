window.pandifyApp.directive 'spotifyAuthLogin', ->
  restrict: 'A'
  templateUrl: 'angular/templates/spotify_auth_login.html'
  scope:
    filteredTracks: '='

  controller: [
    '$scope',
    '$timeout',
    'spotifyAuth',
    ($scope, $timeout, spotifyAuth) ->

      uploadTracks = (onDone) ->
        spotifyApi = new SpotifyWebApi()
        spotifyApi.setAccessToken(spotifyAuth.getAccessToken())
        spotifyAuth.uploadTracks(
          spotifyApi,
          $scope.playlistName,
          ($scope.filteredTracks.map (track) -> track.uri),
          onDone
        )

      setLoginTimeout = ->
        $timeout(
          -> $scope.loggedIn = false,
          spotifyAuth.getTimeUntilExpire()
        )

      $scope.loggedIn = !!spotifyAuth.getAccessToken()
      $scope.playlistName = ''
      $scope.exporting = false
      $scope.exportFinished = false

      setLoginTimeout() if $scope.loggedIn
      $scope.$on 'spotifyLoggedIn', (event, data) ->
        spotifyAuth.setAccessToken(data.access_token, data.expires_in)

        $scope.$apply -> $scope.loggedIn = true
        setLoginTimeout()

      $scope.openLoginWindow = ->
        spotifyAuth.openLoginWindow()

      $scope.exportPlaylist = ->
        $scope.exporting = true
        $scope.exportFinished = false

        uploadTracks ->
          $scope.$apply ->
            $scope.exporting = false
            $scope.exportFinished = true
  ]

  link: ($scope, element, attrs) ->
    $scope.$watch 'loggedIn', (newVal) ->
      # Doesn't work if the developer console is open.
      $(element).find('input[name=playlistName]').focus() if newVal
