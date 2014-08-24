NavMenuCtrl = ($rootScope, $location, SpotifyTracksMatcher) ->
  vm = @

  $rootScope.$on '$routeChangeStart', (event, next, current) ->
    vm.hasPandoraTracks = SpotifyTracksMatcher.getTracksToMatch().length > 0

    $location.path('/configure') unless vm.hasPandoraTracks

    vm.activeMenu = $location.url().slice(1)

  vm

navMenu = ->
  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/nav_menu.html'
  controller: NavMenuCtrl
  controllerAs: 'vm'

NavMenuCtrl.$inject = ['$rootScope', '$location', 'SpotifyTracksMatcher']
angular.module('pandify').directive('navMenu', navMenu)
