$ '.send'
  .click ->
    $context = $ this
    $.ajax
      url: "https://kelder.zeus.ugent.be/messages/",
      contentType: "text/plain",
      type: "POST"
      data: $('.chatbox').val()
      success: -> $('#chat-response').text('Success! :)')
      error: -> $('#chat-response').text('Error !1!')
