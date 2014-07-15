window.pandifyApp.factory 'trackData', ->

  new class TrackData
    MAX_REQUESTS = 3
    FAILURE_WAIT_TIME = 2000

    constructor: ->
      @spotifyApi = new SpotifyWebApi()
      @requestsOut = 0 # Number of concurrent requests
      @artistGenreCache = {}
      @tracksToQuery = [] # Queue of tracks to query for.

    # Adds the track to the query queue.
    queryTrackData: (track, artist, onDone) ->
      @tracksToQuery.push
        track: track
        artist: artist
        onDone: onDone

      @_downloadTrackData()

    # Exact query for track/artist combination
    # https://support.spotify.com/us/learn-more/faq/#!/article/Advanced-search1
    _trackQuery: (track, artist) ->
      "track:#{track} artist:#{artist}"

    # Returns an array of genres to onDone for the given artists.
    _getGenres: (artistIDs, onDone) ->
      ids = artistIDs.slice(0) # Duplicate the array
      allGenres = []

      for id, i in ids by -1
        if @artistGenreCache[id]?
          allGenres = allGenres.concat(@artistGenreCache[id])
          ids.splice(i, 1)

      if ids.length is 0
        onDone(allGenres)
      else
        @spotifyApi.getArtists(ids).then (data) =>

          for artist in data.artists by 1
            @artistGenreCache[artist.id] = artist.genres
            allGenres = allGenres.concat(artist.genres)

          onDone(allGenres)

        , (error) =>

          setTimeout =>
            @_getGenres(artistIDs, onDone)
          , FAILURE_WAIT_TIME

    # Downloads a track's data and genres from the queue.
    _downloadTrackData: ->
      return if @requestsOut >= MAX_REQUESTS or @tracksToQuery.length is 0

      @requestsOut += 1
      track = @tracksToQuery.pop()

      query = @_trackQuery(track.track, track.artist)
      @spotifyApi.searchTracks(query).then (data) =>
        if data['tracks']['total'] is 0
          track.onDone(null)

          @requestsOut -= 1
          @_downloadTrackData()
        else
          trackData = data['tracks']['items'][0] # First item is the best match.
          artistIDs = trackData.artists.map (artist) -> artist.id

          @_getGenres artistIDs, (genres) =>
            trackData.pandify_artists_genres = genres
            track.onDone(trackData)

            @requestsOut -= 1
            @_downloadTrackData()

      , (error) =>

        setTimeout =>
          @tracksToQuery.unshift(track)
          @requestsOut -= 1
          @_downloadTrackData()
        , FAILURE_WAIT_TIME
