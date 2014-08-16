TracksGenreFilter = ($filter, Session) ->
  filterMethod = Session.get('filterMethod') or 'lazyFilter'
  selectedGenres = Session.get('selectedGenres') or []

  getFilterMethod: ->
    filterMethod

  setFilterMethod: (newFilterMethod) ->
    Session.put('filterMethod', filterMethod = newFilterMethod)

  addGenre: (genre) ->
    return if $.inArray(genre, selectedGenres) isnt -1
    selectedGenres.push(genre)
    Session.put('selectedGenres', selectedGenres)

  removeGenre: (genre) ->
    index = $.inArray(genre, selectedGenres)
    return if index is -1
    selectedGenres.splice(index, 1)
    Session.put('selectedGenres', selectedGenres)

  filter: (tracks) ->
    $filter(filterMethod)(tracks, selectedGenres)

TracksGenreFilter.$inject = ['$filter', 'pandifySession']
angular.module('pandify').factory('TracksGenreFilter', TracksGenreFilter)
