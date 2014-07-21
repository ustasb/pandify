window.pandifyApp.controller 'ConfigureMenuCtrl', [
  '$scope',
  'pandifySession',
  'pandoraData',
  ($scope, session, pandoraData) ->

    $scope.retrieveData = ->
      session.kill()
      session.set('pandoraTracks', pandoraData['liked_tracks'])
]
