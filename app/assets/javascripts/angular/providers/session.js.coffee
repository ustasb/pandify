window.pandifyApp.factory 'pandifySession', ['localStorageService', (localStorage) ->
  new class Session

    setPandoraID: (pandoraID) ->
      @pandoraID = pandoraID
      localStorage.set('pandoraID', pandoraID)
    getPandoraID: ->
      @pandoraID or @pandoraID = localStorage.get('pandoraID')

    setDataToGet: (dataToGet) ->
      @dataToGet = dataToGet
      localStorage.set('dataToGet', dataToGet)
    getDataToGet: ->
      @dataToGet or @dataToGet = localStorage.get('dataToGet')

    setMarket: (market) ->
      @market = market
      localStorage.set('market', market)
    getMarket: ->
      @market or @market = localStorage.get('market')

    setTracks: (tracks) ->
      @tracks = tracks
      localStorage.set('tracks', tracks)
    getTracks: ->
      @tracks or @tracks = localStorage.get('tracks')

    setActiveGenreFilters: (genreFilters) ->
      @genreFilters = genreFilters
      localStorage.set('activeGenreFilters', genreFilters)
    getActiveGenreFilters: ->
      @genreFilters or @genreFilters = localStorage.get('activeGenreFilters')
]

