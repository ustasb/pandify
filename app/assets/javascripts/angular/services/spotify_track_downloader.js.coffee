class SpotifyTrackDownloader

  @$inject: ['$q']

  constructor: (@$q) ->
    @spotifyApi = new SpotifyWebApi()
    @artistGenreCache = {}

  downloadTrack: (track, artist) ->
    onTrackDownload = (trackMatch) =>
      @downloadGenres(trackMatch) if trackMatch?

    @_downloadTrack(track, artist).then(onTrackDownload)

  # Exact query for track/ artist combination.
  # https://support.spotify.com/us/learn-more/faq/#!/article/Advanced-search1
  _trackQuery: (track, artist) ->
    "track:#{track} artist:#{artist}"

  # Queries Spotify for a track.
  _downloadTrack: (track, artist) ->
    deferred = @$q.defer()

    onSuccess = (response) =>
      if response['tracks']['total'] is 0
        deferred.resolve()
      else
        trackMatch = response['tracks']['items'][0] # The first track is the best match!
        deferred.resolve(trackMatch)

    onFailure = -> alert('Failed to download track: ' + track)

    @spotifyApi.searchTracks(
      @_trackQuery(track, artist)
    ).then(onSuccess, onFailure)

    deferred.promise

  # Adds the track's artists' genres to the trackMatch object via spotify_artists_genres.
  downloadGenres: (trackMatch) ->
    deferred = @$q.defer()
    artistIDs = trackMatch.artists.map (artist) -> artist.id
    allGenres = []
    idsToQuery = []

    for id in artistIDs by 1
      if @artistGenreCache[id]?
        allGenres = allGenres.concat(@artistGenreCache[id])
      else
        idsToQuery.push(id)

    if idsToQuery.length is 0
      trackMatch.spotify_artists_genres = allGenres
      deferred.resolve(trackMatch)
    else
      onSuccess = (response) =>
        for artist in response.artists by 1
          @artistGenreCache[artist.id] = artist.genres
          allGenres = allGenres.concat(artist.genres)

        trackMatch.spotify_artists_genres = allGenres
        deferred.resolve(trackMatch)

      onFailure = -> alert('Failed to download genres for: ' + trackMatch)

      @spotifyApi.getArtists(idsToQuery).then(onSuccess, onFailure)

    deferred.promise

angular.module('pandify').service('SpotifyTrackDownloader', SpotifyTrackDownloader)
