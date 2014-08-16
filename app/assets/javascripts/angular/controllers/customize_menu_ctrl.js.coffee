CustomizeMenuCtrl = ($scope, $location, Session, SpotifyTracksMatcher) ->
  vm = @

  onAddGenre = (e, genre) ->
    return if $.inArray(genre, vm.selectedGenres) isnt -1
    vm.selectedGenres.push(genre)
    Session.put('selectedGenres', vm.selectedGenres)

  onRemoveGenre = (e, genre) ->
    index = $.inArray(genre, vm.selectedGenres)
    return if index is -1
    vm.selectedGenres.splice(index, 1)
    Session.put('selectedGenres', vm.selectedGenres)

  pauseMatching = ->
    Session.put('matchingPaused', vm.matchingPaused = true)
    SpotifyTracksMatcher.pauseMatching()

  resumeMatching = ->
    Session.put('matchingPaused', vm.matchingPaused = false)
    SpotifyTracksMatcher.startMatching()

  vm.pandoraTracksCount = Session.get('user.pandoraTracks').length
  vm.spotifyTrackMatches = SpotifyTracksMatcher.getMatches()

  vm.trackMatchesGenres = SpotifyTracksMatcher.getMatchesGenres()
  vm.selectedGenres = Session.get('selectedGenres') or []

  $scope.$on 'addGenre', onAddGenre
  $scope.$on 'removeGenre', onRemoveGenre

  vm.matchingPaused = JSON.parse(Session.get('matchingPaused'))
  vm.doneMatching = SpotifyTracksMatcher.doneMatching()

  vm.pauseMatching = pauseMatching
  vm.resumeMatching = resumeMatching
  # Default to resume for the first time.
  vm.resumeMatching() if vm.matchingPaused is null

  vm.exportPlaylist = -> $location.path('/create')

  SpotifyTracksMatcher.onDoneMatching -> vm.doneMatching = true
  SpotifyTracksMatcher.onTrackMatch (trackMatch) -> $scope.$broadcast 'trackMatch', trackMatch

  vm

CustomizeMenuCtrl.$inject = ['$scope', '$location', 'pandifySession', 'SpotifyTracksMatcher']
angular.module('pandify').controller('CustomizeMenuCtrl', CustomizeMenuCtrl)
