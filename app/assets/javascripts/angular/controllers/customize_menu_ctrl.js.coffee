CustomizeMenuCtrl = ($location, Session, SpotifyTracksMatcher) ->
  vm = @

  vm.pandoraTracksCount = Session.get('user.pandoraTracks').length
  vm.spotifyTrackMatches = SpotifyTracksMatcher.getMatches()

  vm.matchingPaused = JSON.parse(Session.get('matchingPaused'))
  vm.doneMatching = SpotifyTracksMatcher.doneMatching()

  vm.pauseMatching = ->
    Session.put('matchingPaused', vm.matchingPaused = true)
    SpotifyTracksMatcher.pauseMatching()

  vm.resumeMatching = ->
    Session.put('matchingPaused', vm.matchingPaused = false)
    SpotifyTracksMatcher.startMatching(-> vm.doneMatching = true)

  # Default to resume for the first time.
  vm.resumeMatching() if vm.matchingPaused is null

  vm

CustomizeMenuCtrl.$inject = ['$location', 'pandifySession', 'SpotifyTracksMatcher']
angular.module('pandify').controller('CustomizeMenuCtrl', CustomizeMenuCtrl)
