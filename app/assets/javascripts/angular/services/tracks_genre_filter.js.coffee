TracksGenreFilter = ($filter, Session) ->
  filterMethod = Session.get('filterMethod') or 'lazyFilter'
  selectedGenres = Session.get('selectedGenres') or []

  getFilterMethod: ->
    filterMethod

  setFilterMethod: (newFilterMethod) ->
    Session.put('filterMethod', filterMethod = newFilterMethod)

  # Returns a boolean indicating success
  addGenre: (genre) ->
    return false if $.inArray(genre, selectedGenres) isnt -1
    selectedGenres.push(genre)
    Session.put('selectedGenres', selectedGenres)
    true

  # Returns a boolean indicating success
  removeGenre: (genre) ->
    index = $.inArray(genre, selectedGenres)
    return false if index is -1
    selectedGenres.splice(index, 1)
    Session.put('selectedGenres', selectedGenres)
    true

  filter: (tracks) ->
    $filter(filterMethod)(tracks, selectedGenres)

TracksGenreFilter.$inject = ['$filter', 'Session']
angular.module('pandify').factory('TracksGenreFilter', TracksGenreFilter)
