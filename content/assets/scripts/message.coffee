$ '.send'
  .click ->
    $context = $ this
    $.ajax "https://kelder.zeus.ugent.be/messages",
      type: "POST"
      data: $ '.chatbox'
