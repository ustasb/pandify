CustomizeMenuCtrl = ($scope, $timeout, $location, SpotifyTracksMatcher, TracksGenreFilter) ->
  vm = @

  filterTracks = (filterMethod) ->
    TracksGenreFilter.setFilterMethod(vm.filterMethod = filterMethod) if filterMethod?
    vm.filteredTracks = TracksGenreFilter.filter(vm.spotifyTrackMatches)

  onAddGenre = (e, genre) ->
    if TracksGenreFilter.addGenre(genre)
      vm.filterTracks()
      $scope.$digest()

  onRemoveGenre = (e, genre) ->
    if TracksGenreFilter.removeGenre(genre)
      vm.filterTracks()
      $scope.$digest()

  pauseMatching = ->
    vm.isMatchingPaused = true
    SpotifyTracksMatcher.pauseMatching()

  resumeMatching = ->
    vm.isMatchingPaused = false
    SpotifyTracksMatcher.startMatching()

  saveRawPandoraData = ->
    pandoraTracks = SpotifyTracksMatcher.getTracksToMatch()
    pandoraTracks = JSON.stringify(pandoraTracks, undefined, 2)
    blob = new Blob([pandoraTracks], {type: 'text/plain;charset=utf-8'})
    saveAs(blob, 'raw_pandora_tracks.txt')

  SpotifyTracksMatcher.onDoneMatching ->
    vm.isDoneMatching = true
    vm.hasNoMatches = vm.spotifyTrackMatches.length is 0
  SpotifyTracksMatcher.onTrackMatch (trackMatch) ->
    vm.filterTracks()
    # Broadcast after the digest cycle completes.
    $timeout (-> $scope.$broadcast('trackMatch', trackMatch)), 0

  $scope.$on 'addGenre', onAddGenre
  $scope.$on 'removeGenre', onRemoveGenre
  $scope.$on '$destroy', pauseMatching

  vm.pandoraTracksCount = SpotifyTracksMatcher.getTracksToMatch().length
  vm.spotifyTrackMatches = SpotifyTracksMatcher.getMatches()

  vm.trackMatchesGenres = SpotifyTracksMatcher.getMatchesGenres()
  vm.selectedGenres = TracksGenreFilter.getSelectedGenres()

  vm.filterMethod = TracksGenreFilter.getFilterMethod()
  vm.filterTracks = filterTracks

  vm.isMatchingPaused = SpotifyTracksMatcher.isMatchingPaused()
  vm.isDoneMatching = SpotifyTracksMatcher.isDoneMatching()
  vm.hasNoMatches = vm.spotifyTrackMatches.length is 0

  vm.pauseMatching = pauseMatching
  vm.resumeMatching = resumeMatching

  try
    isFileSaverSupported = !!(new Blob())
    vm.saveRawPandoraData = saveRawPandoraData if isFileSaverSupported
  catch

  vm.exportPlaylist = -> $location.path('/create')

  vm.filterTracks()
  SpotifyTracksMatcher.startMatching() unless vm.isMatchingPaused

  vm

CustomizeMenuCtrl.$inject = ['$scope', '$timeout', '$location', 'SpotifyTracksMatcher', 'TracksGenreFilter']
angular.module('pandify').controller('CustomizeMenuCtrl', CustomizeMenuCtrl)
