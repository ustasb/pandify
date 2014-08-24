SpotifyTracksMatcher = (StateMachine, SpotifyTrackDownloader, SpotifyTrackPresenter) ->
  state = StateMachine.create 'SpotifyTracksMatcher',
    isMatchingPaused: false
    matches: []
    tracksToMatch: []
    trackToMatchIndex: 0
    marketToMatch: 'US'
  matchesGenres = SpotifyTrackPresenter.genres(state.get('matches'))
  onDoneMatching = ->
  onTrackMatch = ->

  getMatches: ->
    state.get('matches')

  getTracksToMatch: ->
    state.get('tracksToMatch')

  getMatchesGenres: ->
    matchesGenres

  onDoneMatching: (onDoneMatchingCB) ->
    onDoneMatching = onDoneMatchingCB

  onTrackMatch: (onTrackMatchCB) ->
    onTrackMatch = onTrackMatchCB

  setTracksToMatch: (tracks) ->
    state.set('tracksToMatch', tracks)
    state.set('trackToMatchIndex', 0)

  setMarketToMatch: (market) ->
    state.set('marketToMatch', market)

  isDoneMatching: ->
    state.get('trackToMatchIndex') >= state.get('tracksToMatch').length

  isMatchingPaused: ->
    state.get('isMatchingPaused')

  startMatching: ->
    state.set('isMatchingPaused', false)
    @match()

  pauseMatching: ->
    state.set('isMatchingPaused', true)

  isTrackValid: (trackMatch) ->
    $.inArray(state.get('marketToMatch'), trackMatch.markets) isnt -1

  saveMatch: (trackMatch) ->
    delete trackMatch.markets # Unnecessary to store this.

    state.update 'matches', (v) -> v.unshift(trackMatch); v

    for genre in trackMatch.genres by 1
      matchesGenres[genre] ?= 0
      ++matchesGenres[genre]

  match: ->
    return if @isMatchingPaused() or @isDoneMatching()

    track = state.get('tracksToMatch')[state.get('trackToMatchIndex')]

    onSuccess = (trackMatch) =>
      state.update 'trackToMatchIndex', (v) -> ++v

      if trackMatch?
        trackMatch = SpotifyTrackPresenter.present(trackMatch)
        if @isTrackValid(trackMatch)
          @saveMatch(trackMatch)
          onTrackMatch(trackMatch)

      if @isDoneMatching()
        onDoneMatching()
      else
        @match()

    SpotifyTrackDownloader.downloadTrackData(track.track, track.artist).then(onSuccess)

SpotifyTracksMatcher.$inject = ['StateMachine', 'SpotifyTrackDownloader', 'SpotifyTrackPresenter']
angular.module('pandify').factory('SpotifyTracksMatcher', SpotifyTracksMatcher)
