$('.ctrl').click ->
  $.ajax "//kelder.zeus.ugent.be/webcam/cgi/ptdc.cgi",
    data:
      command: $(this).attr("command")
      posX: $(this).attr("posX")
      posY: $(this).attr("posY")

$('.ctrl').hide()

timeout = null

$('.fullpage').mousemove (event) ->
  clearTimeout(timeout) if timeout
  $('.ctrl').fadeIn()
  timeout = setTimeout (-> $('.ctrl').fadeOut()), 3000
