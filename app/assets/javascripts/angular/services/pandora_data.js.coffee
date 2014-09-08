PandoraData = ($q, $http) ->

  JSON_API = 'pandora_data/'

  getTracks = (pandoraID, dataToGet) ->
    deferred = $q.defer()

    onSuccess = (data, status, headers, config) ->
      deferred.resolve(data['tracks'])

    onError = (data, status, headers, config) ->
      deferred.reject(status)

    $http(
      url: JSON_API
      method: 'GET'
      params:
        pandora_id: pandoraID
        liked_tracks: dataToGet.likedTracks
        bookmarked_tracks: dataToGet.bookmarkedTracks
    ).success(onSuccess).error(onError)

    deferred.promise

  getTracks: getTracks

PandoraData.$inject = ['$q', '$http']
angular.module('pandify').factory('PandoraData', PandoraData)
