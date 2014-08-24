TracksGenreFilter = ($filter, StateMachine) ->
  state = StateMachine.create 'TracksGenreFilter',
    filterMethod: 'lazyFilter'
    selectedGenres: []

  getFilterMethod: ->
    state.get('filterMethod')

  getSelectedGenres: ->
    state.get('selectedGenres')

  setFilterMethod: (filterMethod) ->
    state.set('filterMethod', filterMethod)

  # Returns a boolean indicating success.
  addGenre: (genre) ->
    return false if $.inArray(genre, state.get('selectedGenres')) isnt -1
    state.update 'selectedGenres', (v) -> v.push(genre); v
    true

  # Returns a boolean indicating success.
  removeGenre: (genre) ->
    index = $.inArray(genre, state.get('selectedGenres'))
    return false if index is -1
    state.update 'selectedGenres', (v) -> v.splice(index, 1); v
    true

  filter: (tracks) ->
    $filter(state.get('filterMethod'))(tracks, state.get('selectedGenres'))

TracksGenreFilter.$inject = ['$filter', 'StateMachine']
angular.module('pandify').factory('TracksGenreFilter', TracksGenreFilter)
