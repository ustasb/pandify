Config = ($routeProvider, localStorageServiceProvider) ->
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

  localStorageServiceProvider.setPrefix('pandify')

Run = ($window, $rootScope) ->
  receiveMessage = (event) ->
    data = JSON.parse(event.originalEvent.data)
    $rootScope.$broadcast('spotifyLoggedIn', data)

  $($window).on('message', receiveMessage)

Config.$inject = ['$routeProvider', 'localStorageServiceProvider']
Run.$inject = ['$window', '$rootScope']

angular.module('pandify', ['ngRoute', 'templates', 'LocalStorageModule'])
  .config(Config)
  .run(Run)
