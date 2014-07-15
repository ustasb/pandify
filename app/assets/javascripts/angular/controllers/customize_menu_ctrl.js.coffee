initGenreSelector = ->
  $('#select-genre').selectize
    plugins: ['remove_button']
    maxItems: null
    valueField: 'id'
    labelField: 'title'
    searchField: 'title'
    create: false

window.pandifyApp.controller 'CustomizeMenuCtrl', ['$scope', 'pandoraData', 'trackData', ($scope, pandoraData, trackData) ->
  initGenreSelector()

  $scope.likedTracks = []
  tracks = pandoraData['liked_tracks']

  for track in tracks by 1
    trackData.queryTrackData track.track, track.artist, (data) ->
      return unless data?

      $scope.$apply ->
        $scope.likedTracks.unshift
          track: data.name
          artist: data.artists[0].name
          play_time: data.duration_ms
          album: data.album.name
]

