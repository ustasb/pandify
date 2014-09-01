ConfigureMenuCtrl = ($location, StateMachine, PandoraData, SpotifyTracksMatcher, UserPreferences, RandomPandoraID) ->
  vm = @

  vm.isRetrievingPandoraTracks = false
  vm.user = UserPreferences.getAll()

  vm.isFormValid = ->
    (vm.user.randomID or vm.configForm.pandoraID.$valid) and
    (vm.user.getLikedTracks or vm.user.getBookmarkedTracks)

  vm.toggleRandomID = ->
    vm.user.randomID = !vm.user.randomID

    if vm.user.randomID
      vm.user.pandoraID = RandomPandoraID.get()
    else
      vm.user.pandoraID = ''

  vm.retrieveData = ->
    vm.isRetrievingPandoraTracks = true
    vm.noTracksToMatch = false

    storeData = (tracks) ->
      SpotifyTracksMatcher.setTracksToMatch(tracks)
      SpotifyTracksMatcher.setMarketToMatch(vm.user.market)
      vm.isRetrievingPandoraTracks = false

    PandoraData.getTracks(
      likedTracks: vm.user.getLikedTracks
      bookmarkedTracks: vm.user.getBookmarkedTracks
    ).then(storeData)

  vm.onSubmit = ->
    StateMachine.destroyAll()
    UserPreferences.set(vm.user)
    vm.retrieveData().then ->
      vm.noTracksToMatch = SpotifyTracksMatcher.getTracksToMatch().length is 0
      $location.path('/customize') unless vm.noTracksToMatch

  vm

ConfigureMenuCtrl.$inject = ['$location', 'StateMachine', 'PandoraData', 'SpotifyTracksMatcher', 'UserPreferences', 'RandomPandoraID']
angular.module('pandify').controller('ConfigureMenuCtrl', ConfigureMenuCtrl)
