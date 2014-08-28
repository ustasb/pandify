HighlightGenre = do ->
  HIGHLIGHT_CLASS = 'genre-highlight'
  current = null

  highlightTargets = do ->
    cachedEls = null
    cachedGenre = null

    (genre) ->
      return cachedEls if genre is cachedGenre
      cachedGenre = genre
      cachedEls = $ ".track-list .#{genre}, .selectize-input div[data-value='#{genre}']"

  highlight = (genre) ->
    unhighlight()
    highlightTargets(genre).addClass(HIGHLIGHT_CLASS)
    current = genre

  unhighlight = (genre = current) ->
    return unless genre?
    highlightTargets(genre).removeClass(HIGHLIGHT_CLASS)
    current = null

  isHighlighted = ->
    !!current

  highlight: highlight
  unhighlight: unhighlight
  isHighlighted: isHighlighted

genreSelect = ($document, GenreUid) ->
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

    onLabelClick = (e) ->
      el = $(e.target)
      if el.hasClass('item') and el.hasClass('active')
        selectize.close()

        genre = el.text().replace(/(.*)\s\(\d+\)×/, '$1')
        genre = GenreUid.getUid(genre)

        HighlightGenre.highlight(genre)

    onDocumentClick = (e) ->
      return unless HighlightGenre.isHighlighted()
      el = $(e.target)
      unless el.hasClass('item') and el.hasClass('active')
        HighlightGenre.unhighlight()

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
    $('.selectize-input').on 'mousedown', '.item', onLabelClick
    $document.on 'mousedown', onDocumentClick
    $scope.$on '$destroy', -> $document.off 'mousedown', onDocumentClick

    for genre, count of $scope.genres
      title = GenreUid.getGenre(genre)
      label = "#{title} (#{count})"
      selectize.addOption(label: label, title: title, value: genre)

    for genre in $scope.selectedGenres by 1
      selectize.addItem(genre)

genreSelect.$inject = ['$document', 'GenreUid']
angular.module('pandify').directive('genreSelect', genreSelect)
