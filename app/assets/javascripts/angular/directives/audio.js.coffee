AudioCtrl = ($scope, Audio) ->
  $scope.isPlaying = false

  $scope.playStop = ->
    if $scope.isPlaying
      Audio.stop()
    else
      Audio.play(
        source: $scope.source
        onEnd: ->
          $scope.isPlaying = false
          $scope.$digest()
      )
    $scope.isPlaying = !$scope.isPlaying

audio = ->
  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/audio.html'
  scope:
    source: '='
  controller: AudioCtrl

AudioCtrl.$inject = ['$scope', 'Audio']
angular.module('pandify').directive('audio', audio)
