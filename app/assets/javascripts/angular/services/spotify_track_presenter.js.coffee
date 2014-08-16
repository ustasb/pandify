SpotifyTrackPresenter = ($filter) ->

  present: (trackMatch) ->
    album: trackMatch.album.name
    albumArt: trackMatch.album.images.shift()
    artist: trackMatch.artists[0].name
    durationMS: trackMatch.duration_ms
    genres: trackMatch.pandify_artists_genres
    markets: trackMatch.available_markets
    previewURL: trackMatch.previewURL
    track: trackMatch.name
    uri: trackMatch.uri

  genres: (tracks) ->
    genres = {}

    for track in tracks by 1
      for genre in track.genres by 1
        genres[genre] ?= 0
        ++genres[genre]

    genres

  humanTime: (tracks) ->
    sum = 0
    sum += track.durationMS for track in tracks by 1
    $filter('humanTime')(sum)

SpotifyTrackPresenter.$inject = ['$filter']
angular.module('pandify').factory('SpotifyTrackPresenter', SpotifyTrackPresenter)
