RandomPandoraID = ->

  ids = [
    'bjjustas'
    'tconrad'
  ]

  get = ->
    index = Math.floor(Math.random() * ids.length)
    ids[index]

  get: get

angular.module('pandify').service('RandomPandoraID', RandomPandoraID)
