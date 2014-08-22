CountrySelectLink = ($scope, element, attrs) ->
  select = element.selectize(
    valueField: 'alpha-2'
    labelField: 'name'
    searchField: 'name'
    sortField: 'name'
    onChange: (alpha2) -> $scope.market = alpha2
  )[0].selectize

  select.addOption($scope.countryCodes)
  select.addItem($scope.market)

CountrySelectCtrl = ($scope, countryCodes) ->
  $scope.countryCodes = countryCodes

countrySelect = ->
  restrict: 'A'
  replace: true
  template: '<select></select>'
  scope:
    market: '='
  link: CountrySelectLink
  controller: CountrySelectCtrl

CountrySelectCtrl.$inject = ['$scope', 'iso_3166-1_alpha-2_codes']
angular.module('pandify').directive('countrySelect', countrySelect)
