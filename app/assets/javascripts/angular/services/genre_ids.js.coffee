window.pandifyApp.factory 'genreID', ->
  id = 0
  genres = {}

  getID: (genre) ->
    genre = genre.toLowerCase()
    genres[genre] or genres[genre] = ++id
