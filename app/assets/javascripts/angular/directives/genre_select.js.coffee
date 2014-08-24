GenreSelectLink = ($scope, element, attrs) ->
  selectize = element.selectize(
    plugins: ['remove_button']
    labelField: 'title'
    valueField: 'value'
    searchField: 'value'
    sortField: 'value'
    onItemAdd: (genre) -> $scope.$emit('addGenre', genre)
    onItemRemove: (genre) -> $scope.$emit('removeGenre', genre)
  )[0].selectize

  onTrackMatch = (e, trackMatch) ->
    # More efficient than watching $scope.genres. Only updates genres related
    # to the newly matched track.
    for genre in trackMatch.genres by 1
      count = $scope.genres[genre]

      if count is 1 # Genre hasn't been added to the options list yet.
        selectize.addOption(title: "#{genre} (#{count})", value: genre)
      else
        selectize.updateOption(genre, title: "#{genre} (#{count})", value: genre)

    null

  $scope.$on 'trackMatch', onTrackMatch

  for genre, count of $scope.genres
    selectize.addOption(title: "#{genre} (#{count})", value: genre)

  for genre in $scope.selectedGenres by 1
    selectize.addItem(genre)

genreSelect = ->
  restrict: 'A'
  replace: true
  template: '<input type="text">'
  scope:
    genres: '='
    selectedGenres: '='
  link: GenreSelectLink

angular.module('pandify').directive('genreSelect', genreSelect)
