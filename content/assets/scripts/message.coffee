$ '.send'
  .click ->
    $context = $ this
    $.ajax
      url: "https://kelder.zeus.ugent.be/messages/",
      contentType: "text/plain",
      type: "POST"
      data: $('.chatbox').val()
      success: _ -> $('#chat-response').text('Success! :)')
      error: _ -> $('#chat-response').text('Error !1!')
