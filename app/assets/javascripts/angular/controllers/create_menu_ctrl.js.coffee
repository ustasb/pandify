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

init = ->
  if hasFlash()
    new ZeroClipboard( $('#copy') )
  else
    $('#copy').hide()

window.pandifyApp.controller 'CreateMenuCtrl', ['$scope', ($scope) ->
  init()
]
