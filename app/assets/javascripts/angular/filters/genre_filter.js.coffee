window.pandifyApp.filter 'genre', ->

  # A track must contain at least 1 filter genre.
  lazyFilter = (tracks, genres) ->
    return tracks unless genres.length > 0

    filtered = []

    for track in tracks by 1
      for genre in genres by 1
        if $.inArray(genre, track.genres) isnt -1
          filtered.push(track)
          break

    filtered

  # A track must contain all filter genres.
  strictFilter = (tracks, genres) ->
    return tracks unless genres.length > 0

    filtered = []

    for track in tracks by 1
      valid = true

      for genre in genres by 1
        if $.inArray(genre, track.genres) is -1
          valid = false
          break

      filtered.push(track) if valid

    filtered

  (tracks, genres = [], lazy = true) ->
    if lazy
      lazyFilter(tracks, genres)
    else
      strictFilter(tracks, genres)
