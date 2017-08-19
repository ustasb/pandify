ConfigureMenuCtrl = ($location, StateMachine, PandoraData, SpotifyTracksMatcher, UserPreferences, RandomPandoraID) ->
  vm = @

  isFormValid = ->
    vm.user.randomID or vm.configForm.pandoraID.$valid

  toggleRandomID = ->
    vm.user.randomID = !vm.user.randomID

    if vm.user.randomID
      vm.user.pandoraID = RandomPandoraID.get()
    else
      vm.user.pandoraID = ''

  retrieveData = ->
    vm.submitStatus = ''
    vm.isRetrievingPandoraTracks = true

    PandoraData.getTracks(vm.user.pandoraID)
      .finally -> vm.isRetrievingPandoraTracks = false

  onSubmit = ->
    onRetrieveSuccess = (tracks) ->
      if tracks.length is 0
        vm.submitStatus = 'No Pandora data found for that email.'
      else
        StateMachine.destroyAll()

        UserPreferences.set(vm.user)
        SpotifyTracksMatcher.setTracksToMatch(tracks)
        SpotifyTracksMatcher.setMarketToMatch(vm.user.market)

        $location.path('/customize')

    onRetrieveError = (responseCode) ->
      if responseCode is 404
        vm.submitStatus = "Couldn't find a Pandora account associated with that email."
      else
        vm.submitStatus = 'Some unexpected error occurred! Try again later...'

    retrieveData()
      .then(onRetrieveSuccess, onRetrieveError)

  vm.isFormValid = isFormValid
  vm.toggleRandomID = toggleRandomID
  vm.onSubmit = onSubmit

  vm.isRetrievingPandoraTracks = false
  vm.user = UserPreferences.getAll()

  vm

ConfigureMenuCtrl.$inject = ['$location', 'StateMachine', 'PandoraData', 'SpotifyTracksMatcher', 'UserPreferences', 'RandomPandoraID']
angular.module('pandify').controller('ConfigureMenuCtrl', ConfigureMenuCtrl)
