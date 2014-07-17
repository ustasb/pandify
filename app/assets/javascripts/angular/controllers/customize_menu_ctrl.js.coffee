initSelectize = (onChange) ->
  $('#select-genre').selectize(
    plugins: ['remove_button']
    valueField: 'title'
    labelField: 'title'
    searchField: 'title'
    sortField: 'title'
    onChange: onChange
  )[0].selectize

window.pandifyApp.controller 'CustomizeMenuCtrl', [
  '$scope',
  'pandoraData',
  'trackDataDownloader',
  'trackDataExtractor',
  '$filter',
  'genreID',
  'pandifySession',
  ($scope, pandoraData, downloader, extractor, $filter, genreID, session) ->

    selectize = initSelectize (value) ->
      genres = value.split(',')
      session.setActiveGenreFilters(genres)

      $scope.$apply ->
        if value
          genreIDs = genres.map (genre) -> genreID.getID(genre)
          $scope.likedTracks = $filter('genre')(session.getTracks(), genreIDs)
        else
          $scope.likedTracks = session.getTracks()

    tracks = session.getTracks()

    if tracks
      $scope.likedTracks = tracks

      for track in tracks by 1
        for genre in track.genres by 1
          selectize.addOption(title: genre)

      selectedGenres = session.getActiveGenreFilters() || []
      selectize.addItem(genre) for genre in selectedGenres by 1
    else
      $scope.likedTracks = []
      tracks = pandoraData['liked_tracks']

      for track in tracks by 1
        downloader.queryTrackData track.track, track.artist, (trackData) ->
          return unless trackData?

          track = extractor.extract(trackData)

          selectize.addOption(title: genre) for genre in track.genres by 1

          $scope.$apply ->
            $scope.likedTracks.unshift(track)
            session.setTracks($scope.likedTracks)

        null
]
