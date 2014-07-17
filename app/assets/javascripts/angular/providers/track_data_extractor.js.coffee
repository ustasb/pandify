window.pandifyApp.factory 'trackDataExtractor', ['genreID', (genreID) ->

  extract: (trackData) ->
    album: trackData.album.name
    albumArt: trackData.album.images.pop().url
    artist: trackData.artists[0].name
    durationMS: trackData.duration_ms
    genres: trackData.pandify_artists_genres
    genreIDs: trackData.pandify_artists_genres.map (genre) -> genreID.getID(genre)
    markets: trackData.available_markets
    previewURL: trackData.previewURL
    track: trackData.name
    uri: trackData.uri
]
