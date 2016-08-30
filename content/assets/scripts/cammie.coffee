# Reworked version of the underscorejs debounce
debounce = (func, wait, initial = () -> ) ->
  timeout  = false
  () ->
    context = this
    args = arguments
    later = () ->
      timeout = null
      func.apply context, args
    callNow = !timeout
    clearTimeout timeout
    timeout = setTimeout later, wait
    initial.apply context, args if callNow

# Display controls when moving mouse
$ "#cammie-ctrls"
  .mousemove debounce () ->
      $ this
        .removeClass 'display'
    , 3000, () ->
      $ this
        .addClass 'display'

# Cammie controls
$ '.ctrl'
  .click ->
    $context = $ this
    $.ajax "//kelder.zeus.ugent.be/webcam/cgi/ptdc.cgi",
      data:
        command: $context.data 'command'
        posX: $context.data 'x'
        posY: $context.data 'y'