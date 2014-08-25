Session = ->
  primaryKey = 'Pandify'
  cache = {}

  kill = ->
    cache = {}
    localStorage.clear()

  getKey = (key) ->
    primaryKey + '.' + key

  get = (key) ->
    key = getKey(key)
    cache[key] or cache[key] = angular.fromJson(localStorage.getItem(key))

  put = (key, value) ->
    key = getKey(key)
    cache[key] = value
    localStorage.setItem(key, angular.toJson(value))

  kill: kill
  get: get
  put: put

angular.module('pandify').factory('Session', Session)
