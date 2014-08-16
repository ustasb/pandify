SpotifyTracksMatcher = (Session, SpotifyTrackDownloader, SpotifyTrackPresenter) ->
  pauseMatching = true
  matches = Session.get('matches') or []
  tracksToMatch = Session.get('tracksToMatch') or []

  init: (toMatch) ->
    pauseMatching = true
    Session.put('matches', matches = [])
    # Copy the array - it's going to change.
    Session.put('tracksToMatch', tracksToMatch = toMatch.slice(0))

  doneMatching: () ->
    tracksToMatch.length is 0

  getMatches: ->
    matches

  startMatching: (onDone) ->
    pauseMatching = false
    @match(onDone)

  pauseMatching: ->
    pauseMatching = true

  match: (onDone) ->
    return if pauseMatching

    track = tracksToMatch.pop()
    return unless track?

    onSuccess = (trackMatch) =>
      Session.put('tracksToMatch', tracksToMatch)

      if trackMatch?
        trackMatch = SpotifyTrackPresenter.present(trackMatch)
        matches.push(trackMatch)
        Session.put('matches', matches)

      if tracksToMatch.length is 0
        onDone()
      else
        @match(onDone)

    SpotifyTrackDownloader.downloadTrack(track.track, track.artist).then(onSuccess)

SpotifyTracksMatcher.$inject = ['pandifySession', 'SpotifyTrackDownloader', 'SpotifyTrackPresenter']
angular.module('pandify').factory('SpotifyTracksMatcher', SpotifyTracksMatcher)
