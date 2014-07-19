window.pandifyApp.directive 'zeroClipboard', ->

  ($scope, element, attrs) ->

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

    if hasFlash()
      new ZeroClipboard(element)
    else
      element.hide()
