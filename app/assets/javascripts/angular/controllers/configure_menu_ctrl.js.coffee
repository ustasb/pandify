window.pandifyApp.controller 'ConfigureMenuCtrl', [
  '$scope',
  'pandifySession',
  'pandoraData',
  ($scope, session, pandoraData) ->

    $scope.retrieveData = ->
      session.kill()
      session.set('pandoraTracksToQuery', pandoraData['liked_tracks'])
      session.set('initPandoraTracksCount', pandoraData['liked_tracks'].length)
]
