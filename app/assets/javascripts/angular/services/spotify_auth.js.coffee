# Obtains parameters from the hash of the URL.
getHashParams = ->
  hashParams = {}

  r = /([^&;=]+)=?([^&;]*)/g
  q = window.location.hash.substring(1)

  while e = r.exec(q)
    hashParams[e[1]] = decodeURIComponent(e[2])

  hashParams

# Opens a pop-up in the center of the screen.
popUpWindow = (url, w, h) ->
  left = (screen.width / 2) - (w / 2)
  top = (screen.height / 2) - (h / 2)

  window.open url, '_blank',
    "toolbar=no, location=no, directories=no, status=no, menubar=no," +
    "scrollbars=no, resizable=no, copyhistory=no," +
    "width=#{w}, height=#{h}, top=#{top}, left=#{left}"

SpotifyAuth = (StateMachine) ->
  MAX_URIS_TO_UPLOAD = 100 # Spotify only allows 100 to be uploaded at once.
  AUTH_URL = 'https://accounts.spotify.com/authorize'
  CLIENT_ID = '03032125d76342e4b2174ae143ca9aa1'
  REDIRECT_URI = 'http://localhost:3000/spotify_auth_callback.html'
  SCOPES = 'playlist-modify-private playlist-read-private'

  state = StateMachine.create 'SpotifyAuth',
    accessToken: null
    accessTokenExpiresAt: null

  setAccessToken = (token, expiresInSecs) ->
    nowInMS = (new Date()).getTime()
    expiresInMS = expiresInSecs * 1000
    state.set('accessToken', token)
    state.set('accessTokenExpiresAt', nowInMS + expiresInMS)

  getAccessToken = ->
    token = state.get('accessToken')
    return unless token?
    expireTime = state.get('accessTokenExpiresAt')
    now = (new Date()).getTime()
    return token if expireTime > now

  getTimeUntilExpire = ->
    expireTime = state.get('accessTokenExpiresAt')
    now = (new Date()).getTime()
    expireTime - now

  openLoginWindow = ->
    url = AUTH_URL
    url += '?response_type=token'
    url += '&client_id=' + encodeURIComponent(CLIENT_ID)
    url += '&scope=' + encodeURIComponent(SCOPES)
    url += '&redirect_uri=' + encodeURIComponent(REDIRECT_URI)

    popUpWindow(url, 500, 500)

    null # Angular doesn't like a window being returned...

  uploadTracks = (spotifyApi, playlistName, trackURIs, onDone) ->
    userID = ''
    trackURIs = angular.copy(trackURIs) # This array will be manipulated.

    assignUserID = (data) -> userID = data.id
    assignUserIDError = (err) -> alert('Error retrieving user information!')

    createPlaylist = (data) -> spotifyApi.createPlaylist(userID, name: playlistName, public: false)
    createPlaylistError = (err) -> alert('Error creating playlist!')

    uploadTracks = (data) ->
      playlistID = data.id
      addTracksToPlaylist(spotifyApi, userID, playlistID, trackURIs, onDone)
    uploadTracksError = (err) -> alert('Error uploading tracks!')

    spotifyApi.getMe()
    .then(assignUserID, assignUserIDError)
    .then(createPlaylist, createPlaylistError)
    .then(uploadTracks, uploadTracksError)

  addTracksToPlaylist = (spotifyApi, userID, playlistID, trackURIs, onDone) ->
    uploadURIS = trackURIs.splice(0, MAX_URIS_TO_UPLOAD)

    addTracks = (data) ->
      if trackURIs.length is 0
        onDone()
      else
        addTracksToPlaylist(spotifyApi, userID, playlistID, trackURIs, onDone)
    addTracksError = (err) -> onError('Error uploading tracks!')

    spotifyApi.addTracksToPlaylist(userID, playlistID, uploadURIS)
      .then(addTracks, addTracksError)

  setAccessToken: setAccessToken
  getAccessToken: getAccessToken
  getTimeUntilExpire: getTimeUntilExpire
  openLoginWindow: openLoginWindow
  uploadTracks: uploadTracks

SpotifyAuth.$inject = ['StateMachine']
angular.module('pandify').factory('SpotifyAuth', SpotifyAuth)
