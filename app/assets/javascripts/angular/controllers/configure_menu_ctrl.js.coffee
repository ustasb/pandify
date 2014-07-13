initMarketDropDown = (countryCodes) ->
  select = $('#select-market').selectize(
    valueField: 'alpha-2'
    labelField: 'name'
    searchField: 'name'
    sortField: 'name'
  )[0].selectize

  select.addOption(countryCodes)

window.pandifyApp.controller 'ConfigureMenuCtrl', ['$scope', 'iso_3166-1_alpha-2_codes', ($scope, countryCodes) ->
  initMarketDropDown(countryCodes)
]
