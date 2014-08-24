CreateMenuCtrl = (SpotifyTracksMatcher, TracksGenreFilter) ->
  vm = @

  filteredTracks = TracksGenreFilter.filter(SpotifyTracksMatcher.getMatches())
  vm.hasFilteredTracks = filteredTracks.length > 0
  vm.filteredTracksURIs = filteredTracks.map (track) -> track.uri

  vm

CreateMenuCtrl.$inject = ['SpotifyTracksMatcher', 'TracksGenreFilter']
angular.module('pandify').controller('CreateMenuCtrl', CreateMenuCtrl)
