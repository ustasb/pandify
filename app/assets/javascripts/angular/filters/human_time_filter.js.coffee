window.pandifyApp.filter 'humanTime', ->
  (timeMS) ->
    ms = timeMS % 1000
    timeMS = (timeMS - ms) / 1000
    secs = timeMS % 60
    timeMS = (timeMS - secs) / 60
    mins = timeMS % 60
    hrs = (timeMS - mins) / 60

    str = ''
    str += "#{hrs} hours and " if hrs > 0
    str += "#{mins} minutes"
