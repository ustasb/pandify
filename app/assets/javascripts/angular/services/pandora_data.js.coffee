PandoraData = ($q, RawPandoraData) ->

  getTracks = (dataToGet) ->
    deferred = $q.defer()

    getData = ->
      deferred.resolve(RawPandoraData['tracks'])

    # Simulate fetching from the server.
    setTimeout(getData, 4000)

    deferred.promise

  getTracks: getTracks

PandoraData.$inject = ['$q', 'RawPandoraData']
angular.module('pandify').factory('PandoraData', PandoraData)
