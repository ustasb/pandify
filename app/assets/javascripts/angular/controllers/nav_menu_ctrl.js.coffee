window.pandifyApp.controller 'navMenuCtrl', [
  '$rootScope'
  '$scope',
  '$location',
  'pandifySession',
  ($root, $scope, $location, session) ->

    $root.$on '$routeChangeStart', (event, next, current) ->
      #$scope.hasTracks = true

      #atCreateOrCustomize = /\/(customize|create)/.test($location.url())
      #hasPandoraTracks = session.get('user.pandoraTracks').length > 0

      #unless hasPandoraTracks
        #$scope.hasTracks = false
        #$location.path('/configure') if atCreateOrCustomize

      #$scope.activeMenu = $location.url().slice(1)
]
