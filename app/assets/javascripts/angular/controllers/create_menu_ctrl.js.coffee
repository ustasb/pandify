CreateMenuCtrl = (SpotifyTracksMatcher, TracksGenreFilter) ->
  vm = @

  vm.filteredTracks = TracksGenreFilter.filter(SpotifyTracksMatcher.getMatches())
  vm.hasFilteredTracks = vm.filteredTracks.length > 0

  vm

CreateMenuCtrl.$inject = ['SpotifyTracksMatcher', 'TracksGenreFilter']
angular.module('pandify').controller('CreateMenuCtrl', CreateMenuCtrl)
