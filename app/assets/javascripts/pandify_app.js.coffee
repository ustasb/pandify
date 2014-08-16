window.pandifyApp = angular.module('pandify', ['ngRoute', 'templates', 'LocalStorageModule'])

window.pandifyApp.config ['$routeProvider', ($routeProvider) ->
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
    .otherwise
      redirectTo: '/configure'
]

window.pandifyApp.config ['localStorageServiceProvider', (localStorageServiceProvider) ->
  localStorageServiceProvider.setPrefix('pandify')
]

window.pandifyApp.run [
  '$window',
  '$rootScope',
  ($window, $rootScope) ->

    receiveMessage = (event) ->
      data = JSON.parse(event.originalEvent.data)
      $rootScope.$broadcast('spotifyLoggedIn', data)

    $($window).on('message', receiveMessage)
]
