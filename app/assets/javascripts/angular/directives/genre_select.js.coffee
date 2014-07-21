window.pandifyApp.directive 'genreSelect', ->

  restrict: 'A'

  template: '<input type="text" placeholder="e.g. Classic Rock">'

  scope:
    genres: '='
    genreFilters: '='

  link: ($scope, element, attrs) ->

    selectize = element.selectize(
      plugins: ['remove_button']
      valueField: 'title'
      labelField: 'title'
      searchField: 'title'
      sortField: 'title'
      onItemAdd: (genre) ->
        $scope.addGenre(genre)
      onItemRemove: (genre) ->
        $scope.removeGenre(genre)
    )[0].selectize

    $scope.$watchCollection 'genres', ->
      for genre in $scope.genres
        selectize.addOption(title: genre)

    $scope.$watchCollection 'genreFilters', ->
      for genre in $scope.genreFilters
        selectize.addItem(genre)

  controller: ['$scope', 'pandifySession', ($scope, session) ->
    $scope.addGenre = (genre) ->
      if $.inArray(genre, $scope.genreFilters) is -1
        $scope.$apply -> $scope.genreFilters.push(genre)
        session.set('activeGenreFilters', $scope.genreFilters)

    $scope.removeGenre = (genre) ->
      index = $.inArray(genre, $scope.genreFilters)
      $scope.$apply -> $scope.genreFilters.splice(index, 1)
      session.set('activeGenreFilters', $scope.genreFilters)
  ]
