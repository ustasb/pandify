window.pandifyApp.directive 'countrySelect', ->
  template: '<select placeholder="Select a market..."></select>'
  restrict: 'A'
  replace: true

  link: ($scope, element, attrs) ->
    select = element.selectize(
      valueField: 'alpha-2'
      labelField: 'name'
      searchField: 'name'
      sortField: 'name'
    )[0].selectize

    select.addOption($scope.countryCodes)

  controller: ['$scope', 'iso_3166-1_alpha-2_codes', ($scope, countryCodes) ->
    $scope.countryCodes = countryCodes
  ]
