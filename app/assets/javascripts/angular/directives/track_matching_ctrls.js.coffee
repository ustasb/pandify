TrackMatchingCtrlsLink = ($scope, element, attrs) ->
  resume = element.children('.resume')
  pause = element.children('.pause')

  # I hate the flickering background color when the new button shows and
  # takes a second for the hovered style to apply. This fixes that.
  element.on 'click', '.btn', (e) ->
    el = $(e.currentTarget)
    bgColor = el.css('background-color')

    if el.hasClass('pause')
      resume.css 'background-color', bgColor
    else
      pause.css 'background-color', bgColor

  element.on 'mouseleave', '.btn', (e) ->
    $(e.currentTarget).css('background-color', '')

trackMatchingCtrls = ->
  restrict: 'A'
  scope: false
  templateUrl: 'angular/templates/track_matching_ctrls.html'
  link: TrackMatchingCtrlsLink

angular.module('pandify').directive('trackMatchingCtrls', trackMatchingCtrls)
