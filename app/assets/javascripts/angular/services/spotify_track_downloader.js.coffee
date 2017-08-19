SpotifyTrackDownloader = ($q) ->
  spotifyApi = new SpotifyWebApi()
  spotifyApi.setAccessToken(document.getElementById('master-container').dataset.spotifyAccessToken)
  spotifyApi.setPromiseImplementation($q)
  artistGenreCache = {}

  # Helps to improve the search matches.
  sanitizeTrackName = (track) ->
    # Remove any parenthesis
    track = track.replace(/(\(|\[|\{)(.+)(\)|\]|\})/, '$2')

    # Remove references to a remix
    track = track.replace(/\s?(remix|mix|rmx)/i, '')

    track

  # Exact query for track/ artist combination.
  # https://support.spotify.com/us/learn-more/faq/#!/article/Advanced-search1
  trackQuery = (track, artist) ->
    track = sanitizeTrackName(track)
    "track:#{track} artist:#{artist}"

  # Downloads the Spotify track matches for a given track and artist.
  downloadTrackMatches = (track, artist) ->
    deferred = $q.defer()

    onSuccess = (response) -> deferred.resolve(response['tracks']['items'])
    onFailure = -> deferred.reject('Failed to download track matches for: ' + track)

    spotifyApi.searchTracks(
      trackQuery(track, artist)
    ).then(onSuccess, onFailure)

    deferred.promise

  # Retrieves the artists' genres.
  genresFor = (artistIDs) ->
    deferred = $q.defer()
    allGenres = []
    idsToQuery = []

    for id in artistIDs by 1
      if artistGenreCache[id]?
        $.merge(allGenres, artistGenreCache[id])
      else
        idsToQuery.push(id)

    if idsToQuery.length is 0
      deferred.resolve(allGenres)
    else
      onSuccess = (response) ->
        for artist in response.artists by 1
          artistGenreCache[artist.id] = artist.genres
          $.merge(allGenres, artist.genres)
        deferred.resolve(allGenres)

      onFailure = ->
        deferred.reject('Failed to download genres for: ' + angular.toJson(idsToQuery))

      spotifyApi.getArtists(idsToQuery).then(onSuccess, onFailure)

    deferred.promise

  downloadTrackMatches: downloadTrackMatches
  genresFor: genresFor

SpotifyTrackDownloader.$inject = ['$q']
angular.module('pandify').factory('SpotifyTrackDownloader', SpotifyTrackDownloader)
