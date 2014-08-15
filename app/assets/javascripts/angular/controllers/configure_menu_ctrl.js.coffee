ConfigureMenuCtrl = ($location, Session, PandoraData) ->
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
    Session.kill() # Erase all stored state
    Session.set('user.pandoraID', vm.user.pandoraID)
    Session.set('user.getLikedTracks', vm.user.getLikedTracks)
    Session.set('user.getBookmarkedTracks', vm.user.getBookmarkedTracks)
    Session.set('user.market', vm.user.market)

  vm.retrieveData = ->
    vm.retrievingPandoraTracks = true
    storeData = (tracks) -> Session.set('user.pandoraTracks', tracks)
    PandoraData.get(
      likedTracks: vm.user.getLikedTracks
      bookmarkedTracks: vm.user.getBookmarkedTracks
    ).then(storeData)

  vm.onSubmit = ->
    vm.storePreferences()
    vm.retrieveData().then ->
      vm.retrievingPandoraTracks = false
      $location.path('/customize')

  vm

ConfigureMenuCtrl.$inject = ['$location', 'pandifySession', 'PandoraData']
angular.module('pandify').controller('ConfigureMenuCtrl', ConfigureMenuCtrl)
