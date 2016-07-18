$('.ctrl').click ->
  $.ajax "//kelder.zeus.ugent.be/webcam/cgi/ptdc.cgi",
    data:
      command: $(this).attr("command")
      posX: $(this).attr("posX")
      posY: $(this).attr("posY")
