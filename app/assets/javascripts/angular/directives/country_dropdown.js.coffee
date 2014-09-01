CountrySelectLink = ($scope, element, attrs) ->
  selectize = element.selectize(
    valueField: 'alpha-2'
    labelField: 'name'
    searchField: 'name'
    sortField: 'name'
    onChange: (alpha2) -> $scope.market = alpha2
  )[0].selectize

  selectize.addOption($scope.countryCodes)
  selectize.addItem($scope.market)

  $scope.$watch 'disable', (disabled) ->
    if disabled
      selectize.disable()
    else
      selectize.enable()

CountrySelectCtrl = ($scope, countryCodes) ->
  $scope.countryCodes = countryCodes

countrySelect = ->
  restrict: 'A'
  replace: true
  template: '<select></select>'
  scope:
    market: '='
    disable: '='
  link: CountrySelectLink
  controller: CountrySelectCtrl

CountrySelectCtrl.$inject = ['$scope', 'iso_3166-1_alpha-2_codes']
angular.module('pandify').directive('countrySelect', countrySelect)
