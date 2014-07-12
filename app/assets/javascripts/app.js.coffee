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

$ ->
  $('#select-genre').selectize({
    plugins: ['remove_button'],
    maxItems: null,
    valueField: 'id',
    labelField: 'title',
    searchField: 'title',
  })

  $('#select-state').selectize()

  if hasFlash()
    new ZeroClipboard( $('#copy') )
  else
    $('#copy').hide()
