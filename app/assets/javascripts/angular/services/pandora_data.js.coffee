PandoraData = ($q, $http) ->

  JSON_API = 'pandora_data/'

  getTracks = (pandoraID) ->
    deferred = $q.defer()

    onSuccess = (resp) ->
      deferred.resolve(resp.data.tracks)

    onError = (resp) ->
      deferred.reject(resp.status)

    $http(
      url: JSON_API
      method: 'GET'
      params:
        pandora_id: pandoraID
    ).then(onSuccess, onError)

    deferred.promise

  getTracks: getTracks

PandoraData.$inject = ['$q', '$http']
angular.module('pandify').factory('PandoraData', PandoraData)
