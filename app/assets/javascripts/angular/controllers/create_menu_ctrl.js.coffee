CreateMenuCtrl = (SpotifyTracksMatcher, TracksGenreFilter, IEDetect) ->
  vm = @

  filteredTracks = TracksGenreFilter.filter(SpotifyTracksMatcher.getMatches())
  vm.hasFilteredTracks = filteredTracks.length > 0
  vm.filteredTracksURIs = filteredTracks.map (track) -> track.uri
  vm.isIE = IEDetect.isIE()

  vm

CreateMenuCtrl.$inject = ['SpotifyTracksMatcher', 'TracksGenreFilter', 'IEDetect']
angular.module('pandify').controller('CreateMenuCtrl', CreateMenuCtrl)
