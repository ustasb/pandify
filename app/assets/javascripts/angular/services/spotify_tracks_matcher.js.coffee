SpotifyTracksMatcher = (Session, SpotifyTrackDownloader, SpotifyTrackPresenter) ->
  pauseMatching = true

  matches = Session.get('matches') or []
  matchesGenres = SpotifyTrackPresenter.genres(matches)
  tracksToMatch = Session.get('tracksToMatch') or []
  trackToMatchIndex = Session.get('trackToMatchIndex') or 0

  onDoneMatching = ->
  onTrackMatch = ->

  init: (toMatch) ->
    pauseMatching = true

    Session.put('matches', matches = [])
    matchesGenres = {}
    Session.put('tracksToMatch', tracksToMatch = toMatch)
    Session.put('trackToMatchIndex', trackToMatchIndex = 0)

    onDoneMatching = ->
    onTrackMatch = ->

  doneMatching: () ->
    trackToMatchIndex >= tracksToMatch.length

  getMatches: ->
    matches

  getMatchesGenres: ->
    matchesGenres

  onDoneMatching: (onDoneMatchingCB) ->
    onDoneMatching = onDoneMatchingCB

  onTrackMatch: (onTrackMatchCB) ->
    onTrackMatch = onTrackMatchCB

  startMatching: ->
    pauseMatching = false
    @match()

  pauseMatching: ->
    pauseMatching = true

  match: ->
    return if pauseMatching or @doneMatching()

    track = tracksToMatch[trackToMatchIndex]

    onSuccess = (trackMatch) =>
      Session.put('trackToMatchIndex', ++trackToMatchIndex)

      if trackMatch?
        trackMatch = SpotifyTrackPresenter.present(trackMatch)

        matches.push(trackMatch)
        Session.put('matches', matches)

        for genre in trackMatch.genres by 1
          matchesGenres[genre] ?= 0
          ++matchesGenres[genre]

        onTrackMatch(trackMatch)

      if @doneMatching()
        onDoneMatching()
      else
        @match()

    SpotifyTrackDownloader.downloadTrack(track.track, track.artist).then(onSuccess)

SpotifyTracksMatcher.$inject = ['pandifySession', 'SpotifyTrackDownloader', 'SpotifyTrackPresenter']
angular.module('pandify').factory('SpotifyTracksMatcher', SpotifyTracksMatcher)
