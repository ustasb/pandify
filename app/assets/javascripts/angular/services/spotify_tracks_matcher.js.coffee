SpotifyTracksMatcher = (Session, SpotifyTrackDownloader, SpotifyTrackPresenter) ->
  pauseMatching = true
  matches = Session.get('matches') or []
  tracksToMatch = Session.get('tracksToMatch') or []
  trackToMatchIndex = Session.get('trackToMatchIndex') or 0

  init: (toMatch) ->
    pauseMatching = true
    Session.put('matches', matches = [])
    Session.put('tracksToMatch', tracksToMatch = toMatch)
    Session.put('trackToMatchIndex', trackToMatchIndex = 0)

  doneMatching: () ->
    trackToMatchIndex >= tracksToMatch.length

  getMatches: ->
    matches

  startMatching: (onDone) ->
    pauseMatching = false
    @match(onDone)

  pauseMatching: ->
    pauseMatching = true

  match: (onDone) ->
    return if pauseMatching or @doneMatching()

    track = tracksToMatch[trackToMatchIndex]

    onSuccess = (trackMatch) =>
      Session.put('trackToMatchIndex', ++trackToMatchIndex)

      if trackMatch?
        trackMatch = SpotifyTrackPresenter.present(trackMatch)
        matches.push(trackMatch)
        Session.put('matches', matches)

      if @doneMatching()
        onDone()
      else
        @match(onDone)

    SpotifyTrackDownloader.downloadTrack(track.track, track.artist).then(onSuccess)

SpotifyTracksMatcher.$inject = ['pandifySession', 'SpotifyTrackDownloader', 'SpotifyTrackPresenter']
angular.module('pandify').factory('SpotifyTracksMatcher', SpotifyTracksMatcher)
