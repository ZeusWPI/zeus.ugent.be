# All the cammie controls
commands =
  up:
    command: 'set_relative_pos'
    posX:    0
    posY:    10
  down:
    command: 'set_relative_pos'
    posX:    0
    posY:    -10
  left:
    command: 'set_relative_pos'
    posX:    -10
    posY:    0
  right:
    command: 'set_relative_pos'
    posX:    10
    posY:    0

# Initially hide all the controls
$('.ctrl').hide()

$('.ctrl').click ->
  $.ajax "//kelder.zeus.ugent.be/webcam/cgi/ptdc.cgi",
    data: commands[$(this).attr('id')]

timer = undefined
fade_buffer = false
blocking = false

clear_timer = () ->
  clearTimeout timer
  timer = 0

set_timer = () ->
  timer = setTimeout((->
    ctrl_hide()
    fade_buffer = true
  ), 3000)

ctrl_show = () ->
  $('.ctrl').fadeIn()

ctrl_hide = () ->
  $('.ctrl').fadeOut()

block_hide = () ->
  clear_timer()
  blocking = true

unblock_hide = () ->
  set_timer()
  blocking = false

$(document).mousemove ->
  if !blocking
    if !fade_buffer
      clear_timer() if timer
    else
      fade_buffer = false

    ctrl_show()
    set_timer()

$('.ctrl').mouseover(block_hide)
$('.ctrl').mouseout(unblock_hide)

# Timeout when we leave the window
$(document).mouseleave(unblock_hide)
