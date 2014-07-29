# Obtains parameters from the hash of the URL
getHashParams = ->
  hashParams = {}

  r = /([^&;=]+)=?([^&;]*)/g
  q = window.location.hash.substring(1)

  while e = r.exec(q)
    hashParams[e[1]] = decodeURIComponent(e[2])

  hashParams

# Generates a random string containing numbers and letters
generateRandomString = (length) ->
  text = ''
  possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

  for i in [0...length] by 1
    text += possible.charAt(Math.floor(Math.random() * possible.length))

  text

# Opens a pop-up in the center of the screen.
popUpWindow = (url, w, h) ->
  left = (screen.width / 2) - (w / 2)
  top = (screen.height / 2) - (h / 2)

  window.open url, '_blank',
    "toolbar=no, location=no, directories=no, status=no, menubar=no," +
    "scrollbars=no, resizable=no, copyhistory=no," +
    "width=#{w}, height=#{h}, top=#{top}, left=#{left}"

window.pandifyApp.factory 'spotifyAuth', ['pandifySession', (session) ->
  AUTH_URL = 'https://accounts.spotify.com/authorize'
  CLIENT_ID = '03032125d76342e4b2174ae143ca9aa1'
  REDIRECT_URI = 'http://localhost:3000/spotify_auth_callback.html'
  SCOPES = 'playlist-modify-private playlist-read-private'
  STATE_KEY = 'spotify_auth_state'

  new class SpotifyAuth

    setAccessToken: (token, expiresInSecs) ->
      expiresInMS = expiresInSecs * 1000
      session.set('accessToken', token)
      session.set('accessTokenExpires', (new Date()).getTime() + expiresInMS)

    getAccessToken: ->
      token = session.get('accessToken')

      if token
        expireTime = session.get('accessTokenExpires')
        time = (new Date()).getTime()

        return token if expireTime > time

      null

    getTimeUntilExpire: ->
      expireTime = session.get('accessTokenExpires')
      time = (new Date()).getTime()
      expireTime - time

    openLoginWindow: ->
      state = @_getState()

      url = AUTH_URL
      url += '?response_type=token'
      url += '&client_id=' + encodeURIComponent(CLIENT_ID)
      url += '&scope=' + encodeURIComponent(SCOPES)
      url += '&redirect_uri=' + encodeURIComponent(REDIRECT_URI)
      url += '&state=' + encodeURIComponent(state)

      popUpWindow(url, 500, 500)

      null # Angular doesn't like a window to be returned...

    _getState: ->
      state = generateRandomString(16)
      session.set(STATE_KEY, state)
      state
]
