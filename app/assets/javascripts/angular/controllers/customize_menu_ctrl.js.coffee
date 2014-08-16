CustomizeMenuCtrl = ($scope, $location, $filter, Session, SpotifyTracksMatcher, SpotifyTrackPresenter) ->
  vm = @

  filterTracks = (filterMethod) ->
    vm.filterMethod = filterMethod
    vm.filteredTracks = $filter(vm.filterMethod)(vm.spotifyTrackMatches, vm.selectedGenres)

  onAddGenre = (e, genre) ->
    return if $.inArray(genre, vm.selectedGenres) isnt -1
    vm.selectedGenres.push(genre)
    Session.put('selectedGenres', vm.selectedGenres)

    vm.filterTracks(vm.filterMethod)
    $scope.$digest()

  onRemoveGenre = (e, genre) ->
    index = $.inArray(genre, vm.selectedGenres)
    return if index is -1
    vm.selectedGenres.splice(index, 1)
    Session.put('selectedGenres', vm.selectedGenres)

    vm.filterTracks(vm.filterMethod)
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
    vm.filterTracks(vm.filterMethod)

  vm.pandoraTracksCount = Session.get('user.pandoraTracks').length
  vm.spotifyTrackMatches = SpotifyTracksMatcher.getMatches()

  vm.trackMatchesGenres = SpotifyTracksMatcher.getMatchesGenres()
  vm.selectedGenres = Session.get('selectedGenres') or []

  vm.filterMethod = 'lazyFilter'
  vm.filterTracks = filterTracks
  vm.filteredTracks = vm.spotifyTrackMatches

  vm.totalHumanTime = (tracks) -> SpotifyTrackPresenter.humanTime(tracks)

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

CustomizeMenuCtrl.$inject = ['$scope', '$location', '$filter', 'pandifySession', 'SpotifyTracksMatcher', 'SpotifyTrackPresenter']
angular.module('pandify').controller('CustomizeMenuCtrl', CustomizeMenuCtrl)
