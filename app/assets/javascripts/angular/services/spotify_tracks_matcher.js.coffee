SpotifyTracksMatcher = ($q, $timeout, StateMachine, SpotifyTrackDownloader, SpotifyTrackPresenter, GenreUid) ->
  state = StateMachine.create 'SpotifyTracksMatcher',
    isMatchingPaused: false
    matches: []
    tracksToMatch: []
    trackToMatchIndex: 0
    marketToMatch: 'US'

  matchesGenres = SpotifyTrackPresenter.genres(state.get('matches'))
  matchesIDs = SpotifyTrackPresenter.ids(state.get('matches'))
  onDoneMatching = ->
  onTrackMatch = ->

  # Getters
  getMatches = -> state.get('matches')
  getTracksToMatch = -> state.get('tracksToMatch')
  getMatchesGenres = -> matchesGenres

  # Setters
  setTracksToMatch = (tracks) ->
    state.set('tracksToMatch', tracks)
    state.set('trackToMatchIndex', 0)
    matchesGenres = {}
    matchesIDs = {}

  setMarketToMatch = (market) -> state.set('marketToMatch', market)

  onDoneMatching = (onDone) -> onDoneMatching = onDone
  onTrackMatch = (onMatch) -> onTrackMatch = onMatch

  isDoneMatching = ->
    state.get('trackToMatchIndex') >= state.get('tracksToMatch').length

  isMatchingPaused = ->
    state.get('isMatchingPaused')

  startMatching = ->
    state.set('isMatchingPaused', false)
    match()

  pauseMatching = ->
    state.set('isMatchingPaused', true)

  saveMatch = (rawTrackMatch) ->
    trackMatch = SpotifyTrackPresenter.present(rawTrackMatch)

    matchesIDs[trackMatch.id] = trackMatch

    if trackMatch.genres.length is 0
      trackMatch.genres.push('tracks without found genres')

    trackMatch.genres = trackMatch.genres.map (genre) ->
      genre = genre.toLowerCase()
      GenreUid.getUid(genre)

    $.unique(trackMatch.genres)

    for genre in trackMatch.genres by 1
      matchesGenres[genre] ?= 0
      ++matchesGenres[genre]

    delete trackMatch.markets # Unnecessary to store this.

    state.update 'matches', (v) -> v.unshift(trackMatch); v

    onTrackMatch(trackMatch)

  findTrackMatch = (rawTrackMatches) ->
    deferred = $q.defer()
    market = state.get('marketToMatch')

    for track in rawTrackMatches by 1
      # Is the track unique?
      continue if matchesIDs[track.id]?
      # Is the track available in the desired market?
      continue if $.inArray(market, track.available_markets) is -1
      match = track
      break

    if match?
      deferred.resolve(match)
    else
      deferred.reject('No track match found.')

    deferred.promise

  findTrackGenres = (rawTrackMatch) ->
    deferred = $q.defer()
    artistIDs = rawTrackMatch.artists.map (artist) -> artist.id

    assignGenres = (genres) ->
      rawTrackMatch.track_genres = genres
      deferred.resolve(rawTrackMatch)
    assignGenresError = -> deferred.reject('Could not retrieve genres.')

    SpotifyTrackDownloader.genresFor(artistIDs)
      .then(assignGenres, assignGenresError)

    deferred.promise

  match = ->
    return if isMatchingPaused()
    return onDoneMatching() if isDoneMatching()

    trackToMatch = state.get('tracksToMatch')[state.get('trackToMatchIndex')]

    onError = (err) ->
      console.log("An error occurred for #{trackToMatch.track}, #{trackToMatch.artist}: #{err}")

    onFinally = ->
      state.update 'trackToMatchIndex', (v) -> ++v
      $timeout(match, 100) # Prevents Spotify API throttling.

    SpotifyTrackDownloader.downloadTrackMatches(trackToMatch.track, trackToMatch.artist)
      .then(findTrackMatch)
      .then(findTrackGenres)
      .then(saveMatch)
      .catch(onError)
      .finally(onFinally)

  getMatches: getMatches
  getTracksToMatch: getTracksToMatch
  getMatchesGenres: getMatchesGenres
  onDoneMatching: onDoneMatching
  onTrackMatch: onTrackMatch
  setTracksToMatch: setTracksToMatch
  setMarketToMatch: setMarketToMatch
  isDoneMatching: isDoneMatching
  isMatchingPaused: isMatchingPaused
  startMatching: startMatching
  pauseMatching: pauseMatching

SpotifyTracksMatcher.$inject = ['$q', '$timeout', 'StateMachine', 'SpotifyTrackDownloader', 'SpotifyTrackPresenter', 'GenreUid']
angular.module('pandify').factory('SpotifyTracksMatcher', SpotifyTracksMatcher)
