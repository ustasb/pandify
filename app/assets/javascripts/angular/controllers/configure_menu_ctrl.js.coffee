ConfigureMenuCtrl = ($location, $sce, StateMachine, PandoraData, SpotifyTracksMatcher, UserPreferences, RandomPandoraID) ->
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
    vm.projectStatus = ''
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
        vm.projectStatus = $sce.trustAsHtml(
          "<p>Unfortunately, this project is a few years old and I no longer have time to maintain it.</p>" +
          "<p>Pandora changed its website a bit which is probably why Pandify is not working.</p>" +
          "<p>Pandify depends on a tool called <a class=\"underline\" href=\"https://github.com/ustasb/pandata\">Pandata</a> that scrapes Pandora. Feel free to contribute – both <a class=\"underline\" href=\"https://github.com/ustasb/pandify\">Pandify</a> and <a class=\"underline\" href=\"https://github.com/ustasb/pandata\">Pandata</a> are open source.</p>" +
          "<p>Apologies for the inconvenience!</p>"
        )

    retrieveData()
      .then(onRetrieveSuccess, onRetrieveError)

  vm.isFormValid = isFormValid
  vm.toggleRandomID = toggleRandomID
  vm.onSubmit = onSubmit

  vm.isRetrievingPandoraTracks = false
  vm.user = UserPreferences.getAll()

  vm

ConfigureMenuCtrl.$inject = ['$location', '$sce', 'StateMachine', 'PandoraData', 'SpotifyTracksMatcher', 'UserPreferences', 'RandomPandoraID']
angular.module('pandify').controller('ConfigureMenuCtrl', ConfigureMenuCtrl)
