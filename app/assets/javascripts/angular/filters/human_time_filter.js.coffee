humanTime = ->

  # https://gist.github.com/remino/1563878
  (ms) ->
    s = Math.floor(ms / 1000)
    m = Math.floor(s / 60)
    h = Math.floor(m / 60)
    m = m % 60

    if h > 0
      if h is 1
        h += ' hour and '
      else
        h += ' hours and '
    else
      h = ''

    if m is 1
      m += ' minute'
    else
      m += ' minutes'

    h + m

angular.module('pandify').filter('humanTime', humanTime)
