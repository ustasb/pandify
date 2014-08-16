class SpotifyTrackPresenter

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

angular.module('pandify').service('SpotifyTrackPresenter', SpotifyTrackPresenter)

