UserPreferences = (StateMachine) ->
  state = StateMachine.create 'UserPreferences',
    pandoraID: ''
    randomID: false
    getLikedTracks: true
    getBookmarkedTracks: true
    market: 'US'

  getAll = ->
    prefs = {}
    prefs[key] = state.get(key) for key, _ of state.defaults
    prefs

  set = (prefs) ->
    state.setAttrs(prefs)

  getAll: getAll
  set: set

angular.module('pandify').factory('UserPreferences', UserPreferences)
