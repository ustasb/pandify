window.pandifyApp.directive 'countrySelect', ->
  template: '<select placeholder="Select a market..."></select>'
  restrict: 'A'
  replace: true

  scope:
    market: '='

  link: ($scope, element, attrs) ->
    select = element.selectize(
      valueField: 'alpha-2'
      labelField: 'name'
      searchField: 'name'
      sortField: 'name'
      onChange: (alpha2) -> $scope.market = alpha2
    )[0].selectize

    select.addOption($scope.countryCodes)
    select.addItem($scope.market)

  controller: ['$scope', 'iso_3166-1_alpha-2_codes', ($scope, countryCodes) ->
    $scope.countryCodes = countryCodes
  ]
