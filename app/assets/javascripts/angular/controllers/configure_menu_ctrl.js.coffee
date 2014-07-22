window.pandifyApp.controller 'ConfigureMenuCtrl', [
  '$scope',
  '$location',
  'pandifySession',
  'pandoraData',
  ($scope, $location, session, pandoraData) ->

    $scope.user = {}
    $scope.user.pandoraID = session.get('user.pandoraID') or ''
    $scope.user.likedTracks = session.get('user.likedTracks') or true
    $scope.user.bookmarkedTracks = session.get('user.bookmarkedTracks') or true
    $scope.user.market = session.get('user.market') or 'US'

    # Cast string booleans to actual booleans.
    $scope.user.likedTracks = JSON.parse $scope.user.likedTracks
    $scope.user.bookmarkedTracks = JSON.parse $scope.user.bookmarkedTracks

    $scope.formIsValid = ->
      $scope.configForm.pandoraID.$valid and
      ($scope.user.likedTracks or $scope.user.bookmarkedTracks) and
      $scope.user.market

    $scope.retrieveData = ->
      session.kill()

      session.set('user.pandoraID', $scope.user.pandoraID)
      session.set('user.likedTracks', $scope.user.likedTracks)
      session.set('user.bookmarkedTracks', $scope.user.bookmarkedTracks)
      session.set('user.market', $scope.user.market)

      session.set('pandoraTracksToQuery', pandoraData['liked_tracks'])
      session.set('initPandoraTracksCount', pandoraData['liked_tracks'].length)

      $location.path('/customize')
]
