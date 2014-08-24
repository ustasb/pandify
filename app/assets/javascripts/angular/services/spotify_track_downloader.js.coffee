SpotifyTrackDownloader = ($q) ->
  spotifyApi = new SpotifyWebApi()
  artistGenreCache = {}

  downloadTrackData = (track, artist) ->
    onTrackDownload = (trackMatch) -> downloadGenres(trackMatch) if trackMatch?
    downloadTrack(track, artist).then(onTrackDownload)

  # Exact query for track/ artist combination.
  # https://support.spotify.com/us/learn-more/faq/#!/article/Advanced-search1
  trackQuery = (track, artist) ->
    "track:#{track} artist:#{artist}"

  downloadTrack = (track, artist) ->
    deferred = $q.defer()

    onSuccess = (response) ->
      if response['tracks']['total'] is 0
        deferred.resolve()
      else
        # The first track is the best match.
        deferred.resolve(response['tracks']['items'][0])

    onFailure = -> alert('Failed to download track: ' + track)

    spotifyApi.searchTracks(
      trackQuery(track, artist)
    ).then(onSuccess, onFailure)

    deferred.promise

  # Adds the track's artists' genres to the trackMatch object via spotify_artists_genres.
  downloadGenres = (trackMatch) ->
    deferred = $q.defer()
    artistIDs = trackMatch.artists.map (artist) -> artist.id
    allGenres = []
    idsToQuery = []

    for id in artistIDs by 1
      if artistGenreCache[id]?
        $.merge(allGenres, artistGenreCache[id])
      else
        idsToQuery.push(id)

    if idsToQuery.length is 0
      trackMatch.spotify_artists_genres = allGenres
      deferred.resolve(trackMatch)
    else
      onSuccess = (response) ->
        for artist in response.artists by 1
          artistGenreCache[artist.id] = artist.genres
          $.merge(allGenres, artist.genres)

        trackMatch.spotify_artists_genres = allGenres
        deferred.resolve(trackMatch)

      onFailure = -> alert('Failed to download genres for: ' + trackMatch.name)

      spotifyApi.getArtists(idsToQuery).then(onSuccess, onFailure)

    deferred.promise

  downloadTrackData: downloadTrackData

SpotifyTrackDownloader.$inject = ['$q']
angular.module('pandify').factory('SpotifyTrackDownloader', SpotifyTrackDownloader)
