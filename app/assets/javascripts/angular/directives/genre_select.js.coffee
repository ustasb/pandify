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

  for genre, count of $scope.genres
    selectize.addOption(title: "#{genre} (#{count})", value: genre)

  for genre in $scope.selectedGenres by 1
    selectize.addItem(genre)

  $scope.$on 'trackMatch', (e, trackMatch) ->
    for genre in trackMatch.genres by 1
      count = $scope.genres[genre]

      if count is 1
        selectize.addOption(title: "#{genre} (#{count})", value: genre)
      else
        selectize.updateOption(genre, title: "#{genre} (#{count})", value: genre)

    null

genreSelect = ->
  restrict: 'A'
  replace: true
  template: '<input type="text">'
  scope:
    genres: '='
    selectedGenres: '='
  link: GenreSelectLink

angular.module('pandify').directive('genreSelect', genreSelect)
