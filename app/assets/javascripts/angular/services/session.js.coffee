Session = (localStorage) ->
  cache = {}

  init = ->
    cache = {}
    localStorage.clearAll()

  get = (key) ->
    cache[key] or cache[key] = localStorage.get(key)

  put = (key, value) ->
    localStorage.set(key, cache[key] = value)

  init: init
  get: get
  put: put

Session.$inject = ['localStorageService']
angular.module('pandify').factory('Session', Session)
