SpotifyTrackPresenter = ($filter) ->
  id = 0

  getID = ->
    # If the page gets refreshed, using Date ensures that unique IDs are generated.
    (new Date()).getTime() + (id++).toString()

  present = (trackMatch) ->
    id: getID() # URI won't suffice as duplicate track matches are possible.
    album: trackMatch.album.name
    albumArt: trackMatch.album.images.shift()
    artist: trackMatch.artists[0].name
    durationMS: trackMatch.duration_ms
    genres: trackMatch.pandify_artists_genres
    markets: trackMatch.available_markets
    previewURL: trackMatch.previewURL
    track: trackMatch.name
    uri: trackMatch.uri

  genres = (tracks) ->
    genres = {}

    for track in tracks by 1
      for genre in track.genres by 1
        genres[genre] ?= 0
        ++genres[genre]

    genres

  humanTime = (tracks) ->
    sum = 0
    sum += track.durationMS for track in tracks by 1
    $filter('humanTime')(sum)

  present: present
  genres: genres
  humanTime: humanTime

SpotifyTrackPresenter.$inject = ['$filter']
angular.module('pandify').factory('SpotifyTrackPresenter', SpotifyTrackPresenter)
