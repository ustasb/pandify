RandomPandoraID = ->

  ids = [
    'bjjustas'
    'tconrad'
    'chris.newman2'
    'geek279'
    'pnoonan61'
    'rtgiordano'
    'kristiherwarth'
    'maya.baratz'
    'vyoung2'
    'tjgusa5'
    'kellypatrickdugan9'
    'buyeshiro'
    'mgsiegler'
    'joe'
  ]

  get = ->
    index = Math.floor(Math.random() * ids.length)
    ids[index]

  get: get

angular.module('pandify').service('RandomPandoraID', RandomPandoraID)
