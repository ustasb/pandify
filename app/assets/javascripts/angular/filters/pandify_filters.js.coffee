window.pandifyApp.filter 'genre', ->
  (tracks, genres) ->
    filtered = []

    return tracks unless genres?

    for track in tracks by 1
      valid = true

      for genre in genres by 1
        if $.inArray(genre, track.genres) is -1
          valid = false
          break

      filtered.push(track) if valid

    filtered
