CustomizeMenuCtrl = ($scope, $location, SpotifyTracksMatcher, TracksGenreFilter) ->
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

  SpotifyTracksMatcher.onDoneMatching ->
    vm.isDoneMatching = true
  SpotifyTracksMatcher.onTrackMatch (trackMatch) ->
    $scope.$broadcast('trackMatch', trackMatch)
    vm.filterTracks()

  $scope.$on 'addGenre', onAddGenre
  $scope.$on 'removeGenre', onRemoveGenre

  vm.pandoraTracksCount = SpotifyTracksMatcher.getTracksToMatch().length
  vm.spotifyTrackMatches = SpotifyTracksMatcher.getMatches()

  vm.trackMatchesGenres = SpotifyTracksMatcher.getMatchesGenres()
  vm.selectedGenres = TracksGenreFilter.getSelectedGenres()

  vm.filterMethod = TracksGenreFilter.getFilterMethod()
  vm.filterTracks = filterTracks

  vm.isMatchingPaused = SpotifyTracksMatcher.isMatchingPaused()
  vm.isDoneMatching = SpotifyTracksMatcher.isDoneMatching()

  vm.pauseMatching = pauseMatching
  vm.resumeMatching = resumeMatching

  vm.exportPlaylist = -> $location.path('/create')

  vm.filterTracks()
  SpotifyTracksMatcher.startMatching() unless vm.isMatchingPaused

  vm

CustomizeMenuCtrl.$inject = ['$scope', '$location', 'SpotifyTracksMatcher', 'TracksGenreFilter']
angular.module('pandify').controller('CustomizeMenuCtrl', CustomizeMenuCtrl)
