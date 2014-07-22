window.pandifyApp.factory 'pandifySession', ['localStorageService', (localStorage) ->
  new class Session

    constructor: ->
      @cache = {}

    kill: ->
      @cache = {}
      localStorage.clearAll()

    set: (key, value) ->
      @cache[key] = value
      localStorage.set(key, value)

    get: (key) ->
      @cache[key] or @cache[key] = localStorage.get(key)
]
