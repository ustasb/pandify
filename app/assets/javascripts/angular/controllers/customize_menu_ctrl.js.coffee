initGenreSelector = ->
  $('#select-genre').selectize
    plugins: ['remove_button']
    maxItems: null
    valueField: 'id'
    labelField: 'title'
    searchField: 'title'
    create: false

window.pandifyApp.controller 'CustomizeMenuCtrl', ['$scope', 'pandoraData', 'trackDataDownloader', 'trackDataExtractor', ($scope, pandoraData, downloader, extractor) ->
  initGenreSelector()

  $scope.likedTracks = []
  tracks = pandoraData['liked_tracks']

  for track in tracks by 1
    downloader.queryTrackData track.track, track.artist, (trackData) ->
      $scope.$apply ->
        $scope.likedTracks.push extractor.extract(trackData) if trackData?

    null
]
