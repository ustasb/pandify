CustomizeMenuCtrl = ($scope, $location, Session, SpotifyTracksMatcher, TracksGenreFilter) ->
  vm = @

  filterTracks = (filterMethod) ->
    TracksGenreFilter.setFilterMethod(vm.filterMethod = filterMethod) if filterMethod?
    vm.filteredTracks = TracksGenreFilter.filter(vm.spotifyTrackMatches)

  onAddGenre = (e, genre) ->
    TracksGenreFilter.addGenre(genre)
    vm.filterTracks()
    $scope.$digest()

  onRemoveGenre = (e, genre) ->
    TracksGenreFilter.removeGenre(genre)
    vm.filterTracks()
    $scope.$digest()

  pauseMatching = ->
    Session.put('matchingPaused', vm.matchingPaused = true)
    SpotifyTracksMatcher.pauseMatching()

  resumeMatching = ->
    Session.put('matchingPaused', vm.matchingPaused = false)
    SpotifyTracksMatcher.startMatching()

  SpotifyTracksMatcher.onDoneMatching -> vm.doneMatching = true
  SpotifyTracksMatcher.onTrackMatch (trackMatch) ->
    $scope.$broadcast 'trackMatch', trackMatch
    vm.filterTracks()

  vm.pandoraTracksCount = Session.get('user.pandoraTracks').length
  vm.spotifyTrackMatches = SpotifyTracksMatcher.getMatches()

  vm.trackMatchesGenres = SpotifyTracksMatcher.getMatchesGenres()
  vm.selectedGenres = Session.get('selectedGenres') or []

  vm.filterMethod = TracksGenreFilter.getFilterMethod()
  vm.filterTracks = filterTracks
  vm.filteredTracks = vm.spotifyTrackMatches

  $scope.$on 'addGenre', onAddGenre
  $scope.$on 'removeGenre', onRemoveGenre

  vm.matchingPaused = JSON.parse(Session.get('matchingPaused'))
  vm.doneMatching = SpotifyTracksMatcher.doneMatching()

  vm.pauseMatching = pauseMatching
  vm.resumeMatching = resumeMatching
  # Default to resume for the first time.
  vm.resumeMatching() if vm.matchingPaused is null

  vm.exportPlaylist = -> $location.path('/create')

  vm

CustomizeMenuCtrl.$inject = ['$scope', '$location', 'pandifySession', 'SpotifyTracksMatcher', 'TracksGenreFilter']
angular.module('pandify').controller('CustomizeMenuCtrl', CustomizeMenuCtrl)
