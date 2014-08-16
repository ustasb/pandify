CreateMenuCtrl = (SpotifyTracksMatcher, TracksGenreFilter) ->
  vm = @

  vm.filteredTracks = TracksGenreFilter.filter(SpotifyTracksMatcher.getMatches())

  vm

CreateMenuCtrl.$inject = ['SpotifyTracksMatcher', 'TracksGenreFilter']
angular.module('pandify').controller('CreateMenuCtrl', CreateMenuCtrl)
