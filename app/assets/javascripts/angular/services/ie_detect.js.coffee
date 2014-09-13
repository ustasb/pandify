IEDetect = ->

  # http://stackoverflow.com/a/21712356/1575238
  isIE = ->
    ua = window.navigator.userAgent
    msie = ua.indexOf('MSIE ')
    trident = ua.indexOf('Trident/')

    if msie > 0
      # IE 10 or older => return version number
      return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10)

    if trident > 0
      # IE 11 (or newer) => return version number
      rv = ua.indexOf('rv:')
      return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10)

    # other browser
    return false

  isIE: isIE

angular.module('pandify').factory('IEDetect', IEDetect)
