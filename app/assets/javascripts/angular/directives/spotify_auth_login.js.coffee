SpotifyAuthLoginLink = ($scope, element, attrs) ->
  $scope.$watch 'isLoggedIn', (newVal) ->
    # Note: Doesn't work if the developer console is open.
    $(element).find('input[name=playlistName]').focus() if newVal?

SpotifyAuthLoginCtrl = ($rootScope, $scope, $timeout, $q, SpotifyAuth) ->
  uploadTracks = (onDone) ->
    spotifyApi.setAccessToken(SpotifyAuth.getAccessToken())
    SpotifyAuth.uploadTracks(
      spotifyApi,
      $scope.playlistName,
      $scope.tracksUris,
      onDone
    )

  setLoginTimeout = ->
    broadcast = -> $rootScope.$broadcast('spotifyPlaylistFormToggle')

    onTimeout = ->
      $scope.isLoggedIn = false
      $timeout(broadcast, 0) # Triggers after the page has been manipulated.

    $timeout(onTimeout, SpotifyAuth.getTimeUntilExpire())

  onSpotifyLoggedIn = (event, data) ->
    SpotifyAuth.setAccessToken(data.access_token, data.expires_in)

    $scope.isLoggedIn = true
    $scope.$digest()

    setLoginTimeout()

    $rootScope.$broadcast('spotifyPlaylistFormToggle')

  exportPlaylist = ->
    $scope.isExportingPlaylist = true
    $scope.isExportingFinished = false

    uploadTracks ->
      $scope.isExportingPlaylist = false
      $scope.isExportingFinished = true

  spotifyApi = new SpotifyWebApi()
  spotifyApi.setPromiseImplementation($q)

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

SpotifyAuthLoginCtrl.$inject = ['$rootScope', '$scope', '$timeout', '$q', 'SpotifyAuth']
angular.module('pandify').directive('spotifyAuthLogin', spotifyAuthLogin)
