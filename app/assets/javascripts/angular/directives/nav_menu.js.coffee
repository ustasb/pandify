NavMenuCtrl = ($rootScope, $location, Session, SpotifyTracksMatcher) ->
  vm = @

  $rootScope.$on '$routeChangeStart', (event, next, current) ->
    vm.hasPandoraTracks = Session.get('user.pandoraTracks')?.length > 0
    vm.hasSpotifyTrackMatches = SpotifyTracksMatcher.getMatches().length > 0

    if /\/customize/.test($location.url())
      $location.path('/configure') unless vm.hasPandoraTracks
    else if /\/create/.test($location.url())
      $location.path('/configure') unless vm.hasSpotifyTrackMatches

    vm.activeMenu = $location.url().slice(1)

  vm

navMenu = ->
  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/nav_menu.html'
  controller: NavMenuCtrl
  controllerAs: 'vm'

NavMenuCtrl.$inject = ['$rootScope', '$location', 'pandifySession', 'SpotifyTracksMatcher']
angular.module('pandify').directive('navMenu', navMenu)
