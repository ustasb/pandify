SpotifyTrackPresenter = ($filter) ->

  present = (trackMatch) ->
    id: trackMatch.id
    album: trackMatch.album.name
    albumArt: trackMatch.album.images.shift()
    artist: trackMatch.artists[0].name
    durationMS: trackMatch.duration_ms
    genres: trackMatch.track_genres
    markets: trackMatch.available_markets
    previewURL: trackMatch.preview_url
    track: trackMatch.name
    uri: trackMatch.uri

  genres = (tracks) ->
    genres = {}

    for track in tracks by 1
      for genre in track.genres by 1
        genres[genre] ?= 0
        ++genres[genre]

    genres

  ids = (tracks) ->
    ids = {}
    ids[track.id] = track for track in tracks by 1
    ids

  humanTime = (tracks) ->
    sum = 0
    sum += track.durationMS for track in tracks by 1
    $filter('humanTime')(sum)

  present: present
  genres: genres
  ids: ids
  humanTime: humanTime

SpotifyTrackPresenter.$inject = ['$filter']
angular.module('pandify').factory('SpotifyTrackPresenter', SpotifyTrackPresenter)
