ConfigureMenuCtrl = ($location, Session, PandoraData, SpotifyTracksMatcher) ->
  vm = @

  vm.retrievingPandoraTracks = false

  vm.user = {}
  vm.user.pandoraID = Session.get('user.pandoraID') or ''
  vm.user.getLikedTracks = JSON.parse(Session.get('user.getLikedTracks')) or true
  vm.user.getBookmarkedTracks = JSON.parse(Session.get('user.getBookmarkedTracks')) or true
  vm.user.market = Session.get('user.market') or 'US'

  vm.isFormValid = ->
    vm.configForm.pandoraID.$valid and (vm.user.getLikedTracks or vm.user.getBookmarkedTracks)

  vm.storePreferences = ->
    Session.put('user.pandoraID', vm.user.pandoraID)
    Session.put('user.getLikedTracks', vm.user.getLikedTracks)
    Session.put('user.getBookmarkedTracks', vm.user.getBookmarkedTracks)
    Session.put('user.market', vm.user.market)

  vm.retrieveData = ->
    vm.retrievingPandoraTracks = true

    storeData = (tracks) ->
      SpotifyTracksMatcher.init(tracks, vm.user.market)
      vm.retrievingPandoraTracks = false

    PandoraData.getTracks(
      likedTracks: vm.user.getLikedTracks
      bookmarkedTracks: vm.user.getBookmarkedTracks
    ).then(storeData)

  vm.onSubmit = ->
    Session.eraseAll()
    vm.storePreferences()
    vm.retrieveData().then -> $location.path('/customize')

  vm

ConfigureMenuCtrl.$inject = ['$location', 'pandifySession', 'PandoraData', 'SpotifyTracksMatcher']
angular.module('pandify').controller('ConfigureMenuCtrl', ConfigureMenuCtrl)
