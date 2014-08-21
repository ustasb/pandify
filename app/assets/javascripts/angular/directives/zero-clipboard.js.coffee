# Is Flash installed and enabled?
# http://stackoverflow.com/a/20095467/1575238
hasFlash = ->
  try
    flash = new ActiveXObject('ShockwaveFlash.ShockwaveFlash')
    return !!flash
  catch e
    return navigator.mimeTypes and
           navigator.mimeTypes['application/x-shockwave-flash'] isnt undefined and
           navigator.mimeTypes['application/x-shockwave-flash'].enabledPlugin

ZeroClipboardLink = ($scope, element, attrs) ->
  return element.hide() unless hasFlash()

  client = new ZeroClipboard(element)
  messageTime = 2500

  onAfterCopy = ->
    element.addClass('zero-show-message')
    element.blur()

    onTimeout = -> element.removeClass('zero-show-message')
    setTimeout onTimeout, messageTime

  client.on 'ready', -> client.on 'aftercopy', onAfterCopy

zeroClipboard = ->
  restrict: 'A'
  replace: true
  templateUrl: 'angular/templates/zero-clipboard.html'
  link: ZeroClipboardLink

angular.module('pandify').directive('zeroClipboard', zeroClipboard)
