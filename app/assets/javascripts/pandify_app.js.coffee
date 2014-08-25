Config = ($routeProvider) ->
  $routeProvider
    .when '/configure',
      templateUrl: 'angular/templates/configure_menu.html'
      controller: 'ConfigureMenuCtrl'
      controllerAs: 'vm'
    .when '/customize',
      templateUrl: 'angular/templates/customize_menu.html'
      controller: 'CustomizeMenuCtrl'
      controllerAs: 'vm'
    .when '/create',
      templateUrl: 'angular/templates/create_menu.html'
      controller: 'CreateMenuCtrl'
      controllerAs: 'vm'
    .otherwise
      redirectTo: '/configure'

Run = ($window, $rootScope) ->
  # Handles the Spotify login redirect.
  receiveMessage = (event) ->
    data = angular.fromJson(event.originalEvent.data)
    $rootScope.$broadcast('spotifyLoggedIn', data)

  $($window).on('message', receiveMessage)

Config.$inject = ['$routeProvider']
Run.$inject = ['$window', '$rootScope']

angular.module('pandify', ['ngRoute', 'templates'])
  .config(Config)
  .run(Run)
