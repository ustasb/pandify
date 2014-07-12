init = ->
  $('#select-state').selectize()

window.pandifyApp.controller 'ConfigureMenuCtrl', ['$scope', ($scope) ->
  init()
]
