window.pandifyApp.factory 'trackDataExtractor', ->

  extract: (trackData) ->
    album: trackData.album.name
    albumArt: trackData.album.images.pop().url
    artist: trackData.artists[0].name
    durationMS: trackData.duration_ms
    genres: trackData.pandify_artists_genres
    markets: trackData.available_markets
    previewURL: trackData.previewURL
    track: trackData.name
    uri: trackData.uri
