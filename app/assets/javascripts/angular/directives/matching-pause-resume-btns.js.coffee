MatchingPauseResumeBtnsLink = ($scope, element, attrs) ->
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

matchingPauseResumeBtns = ->
  restrict: 'A'
  scope: false
  templateUrl: 'angular/templates/matching-pause-resume-btns.html'
  link: MatchingPauseResumeBtnsLink

angular.module('pandify').directive('matchingPauseResumeBtns', matchingPauseResumeBtns)
