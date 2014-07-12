init = ->
  $('#select-genre').selectize
    plugins: ['remove_button']
    maxItems: null
    valueField: 'id'
    labelField: 'title'
    searchField: 'title'

window.pandifyApp.controller 'CustomizeMenuCtrl', ['$scope', ($scope) ->
  init()
]
