genreSelect = (GenreUid) ->
  restrict: 'A'
  replace: true
  template: '<input type="text">'
  scope:
    genres: '='
    selectedGenres: '='
  link: ($scope, element, attrs) ->
    selectize = element.selectize(
      plugins: ['remove_button']
      labelField: 'label'
      valueField: 'value'
      searchField: 'title'
      sortField: 'title'
      onItemAdd: (genre) -> $scope.$emit('addGenre', genre)
      onItemRemove: (genre) -> $scope.$emit('removeGenre', genre)
    )[0].selectize

    onTrackMatch = (e, trackMatch) ->
      # More efficient than watching $scope.genres. Only updates genres related
      # to the newly matched track.
      for genre in trackMatch.genres by 1
        title = GenreUid.getGenre(genre)
        count = $scope.genres[genre]
        label = "#{title} (#{count})"

        if count is 1 # Genre hasn't been added to the options list yet.
          selectize.addOption(label: label, title: title, value: genre)
        else
          selectize.updateOption(genre, label: label, title: title, value: genre)

      null

    $scope.$on 'trackMatch', onTrackMatch

    for genre, count of $scope.genres
      title = GenreUid.getGenre(genre)
      label = "#{title} (#{count})"
      selectize.addOption(label: label, title: title, value: genre)

    for genre in $scope.selectedGenres by 1
      selectize.addItem(genre)

genreSelect.$inject = ['GenreUid']
angular.module('pandify').directive('genreSelect', genreSelect)
