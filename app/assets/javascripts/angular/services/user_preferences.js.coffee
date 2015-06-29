UserPreferences = (StateMachine) ->
  state = StateMachine.create 'UserPreferences',
    pandoraID: ''
    randomID: false
    getLikedTracks: true
    getBookmarkedTracks: false
    market: 'US'

  getAll = ->
    prefs = {}
    prefs[key] = state.get(key) for key, _ of state.defaults
    prefs

  set = (prefs) ->
    state.setAttrs(prefs)

  getAll: getAll
  set: set

UserPreferences.$inject = ['StateMachine']
angular.module('pandify').factory('UserPreferences', UserPreferences)
