SpotifyAuthLoginLink = ($scope, element, attrs) ->
  $scope.$watch 'loggedIn', (newVal) ->
    # Doesn't work if the developer console is open.
    $(element).find('input[name=playlistName]').focus() if newVal

SpotifyAuthLoginCtrl = ($scope, $timeout, SpotifyAuth) ->
  uploadTracks = (onDone) ->
    spotifyApi = new SpotifyWebApi()
    spotifyApi.setAccessToken(SpotifyAuth.getAccessToken())
    SpotifyAuth.uploadTracks(
      spotifyApi,
      $scope.playlistName,
      ($scope.filteredTracks.map (track) -> track.uri),
      onDone
    )

  setLoginTimeout = ->
    $timeout(
      -> $scope.loggedIn = false,
      SpotifyAuth.getTimeUntilExpire()
    )

  $scope.loggedIn = !!SpotifyAuth.getAccessToken()
  $scope.playlistName = ''
  $scope.exporting = false
  $scope.exportFinished = false

  setLoginTimeout() if $scope.loggedIn
  $scope.$on 'spotifyLoggedIn', (event, data) ->
    SpotifyAuth.setAccessToken(data.access_token, data.expires_in)

    $scope.$apply -> $scope.loggedIn = true
    setLoginTimeout()

  $scope.openLoginWindow = ->
    SpotifyAuth.openLoginWindow()

  $scope.exportPlaylist = ->
    $scope.exporting = true
    $scope.exportFinished = false

    uploadTracks ->
      $scope.$apply ->
        $scope.exporting = false
        $scope.exportFinished = true

spotifyAuthLogin = ->
  restrict: 'A'
  templateUrl: 'angular/templates/spotify_auth_login.html'
  scope:
    filteredTracks: '='
  link: SpotifyAuthLoginLink
  controller: SpotifyAuthLoginCtrl

SpotifyAuthLoginCtrl.$inject = ['$scope', '$timeout', 'SpotifyAuth']
angular.module('pandify').directive('spotifyAuthLogin', spotifyAuthLogin)
