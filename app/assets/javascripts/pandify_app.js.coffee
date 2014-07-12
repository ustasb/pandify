window.pandifyApp = angular.module('pandify', ['ngRoute', 'templates'])

window.pandifyApp.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'angular/templates/configure_menu.html'
      controller: 'ConfigureMenuCtrl'
    .when '/customize',
      templateUrl: 'angular/templates/customize_menu.html'
      controller: 'CustomizeMenuCtrl'
    .when '/create',
      templateUrl: 'angular/templates/create_menu.html'
      controller: 'CreateMenuCtrl'
    .otherwise
      redirectTo: '/'
]
