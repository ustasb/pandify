window.pandifyApp.controller 'CustomizeMenuCtrl', [
  '$scope',
  '$location',
  'trackDataDownloader',
  'trackDataExtractor',
  'pandifySession',
  ($scope, $location, downloader, extractor, session) ->

    $scope.tracks = session.get('tracks') or []
    $scope.initPandoraTracksCount = session.get('initPandoraTracksCount')
    $scope.genreFilters = session.get('activeGenreFilters') or []

    $scope.genres = []
    for track in $scope.tracks
      $scope.genres.push(genre) for genre in track.genres

    pandoraTracks = session.get('pandoraTracksToQuery') or []
    for track, index in pandoraTracks by 1

      do (index) ->
        downloader.queueTrackDownload track.track, track.artist, (trackData) ->
          # The track doesn't need to be queried anymore.
          pandoraTracks.splice(index, 1)
          session.set('pandoraTracksToQuery', pandoraTracks)

          return unless trackData?

          track = extractor.extract(trackData)
          $scope.$apply ->
            $scope.genres.push.apply($scope.genres, track.genres) # Concat the arrays
            $scope.tracks.unshift(track)
            session.set('tracks', $scope.tracks)

      null

    downloader.downloadAll()

    $scope.sumTime = (tracks = []) ->
      sum = 0
      sum += track.durationMS for track in tracks
      sum

    $scope.exportPlaylist = ->
      $location.path('/create')
]
