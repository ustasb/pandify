SpotifyAuthLoginLink = ($scope, element, attrs) ->
  $scope.$watch 'isLoggedIn', (newVal) ->
    # Note: Doesn't work if the developer console is open.
    $(element).find('input[name=playlistName]').focus() if newVal?

SpotifyAuthLoginCtrl = ($scope, $timeout, SpotifyAuth) ->
  uploadTracks = (onDone) ->
    spotifyApi.setAccessToken(SpotifyAuth.getAccessToken())
    SpotifyAuth.uploadTracks(
      spotifyApi,
      $scope.playlistName,
      $scope.tracksUris,
      onDone
    )

  setLoginTimeout = ->
    $timeout(
      -> $scope.isLoggedIn = false,
      SpotifyAuth.getTimeUntilExpire()
    )

  onSpotifyLoggedIn = (event, data) ->
    SpotifyAuth.setAccessToken(data.access_token, data.expires_in)

    $scope.isLoggedIn = true
    $scope.$digest()

    setLoginTimeout()

  exportPlaylist = ->
    $scope.isExportingPlaylist = true
    $scope.isExportingFinished = false

    uploadTracks ->
      $scope.isExportingPlaylist = false
      $scope.isExportingFinished = true
      $scope.$digest()

  spotifyApi = new SpotifyWebApi()

  $scope.$on 'spotifyLoggedIn', onSpotifyLoggedIn
  $scope.openLoginWindow = SpotifyAuth.openLoginWindow
  $scope.exportPlaylist = exportPlaylist

  $scope.playlistName = ''
  $scope.isLoggedIn = !!SpotifyAuth.getAccessToken()
  $scope.isExportingPlaylist = false
  $scope.isExportingFinished = false

  setLoginTimeout() if $scope.isLoggedIn

spotifyAuthLogin = ->
  restrict: 'A'
  templateUrl: 'angular/templates/spotify_auth_login.html'
  scope:
    tracksUris: '='
  link: SpotifyAuthLoginLink
  controller: SpotifyAuthLoginCtrl

SpotifyAuthLoginCtrl.$inject = ['$scope', '$timeout', 'SpotifyAuth']
angular.module('pandify').directive('spotifyAuthLogin', spotifyAuthLogin)
