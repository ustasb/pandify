GenreUid = (StateMachine) ->
  state = StateMachine.create 'GenreUid',
    uid: -1
    genresHash: {}

  updateUid = ->
    uid = null
    state.update 'uid', (v) -> uid = ++v
    "g_#{uid}"

  getUid = (genre) ->
    uid = state.get('genresHash')[genre]
    return uid if uid?

    state.update 'genresHash', (v) ->
      uid = updateUid()
      v[genre] = uid
      v[uid] = genre
      v

    uid

  getGenre = (uid) ->
    state.get('genresHash')[uid]

  getUid: getUid
  getGenre: getGenre

GenreUid.$inject = ['StateMachine']
angular.module('pandify').factory('GenreUid', GenreUid)
