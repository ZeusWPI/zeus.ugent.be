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

$ "#cammie-body"
  .mousemove debounce () ->
      $ this
        .removeClass 'display'
    , 3000, () ->
      $ this
        .addClass 'display'