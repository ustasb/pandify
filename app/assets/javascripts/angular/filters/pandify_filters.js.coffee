window.pandifyApp.filter 'genre', ->
  (tracks, genreIDs) ->
    filtered = []

    for track in tracks by 1
      for genreID in genreIDs by 1
        if $.inArray(genreID, track.genreIDs) isnt -1
          filtered.push(track)
          break

    filtered
