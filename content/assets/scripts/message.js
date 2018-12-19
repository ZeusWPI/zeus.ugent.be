$('.send').click(function() {
  var $context;
  $context = $(this);
  return $.ajax({
    url: "https://kelder.zeus.ugent.be/messages/",
    contentType: "text/plain",
    type: "POST",
    data: $('.chatbox').val(),
    success: function() {
      return $('#chat-response').text('Success! :)');
    },
    error: function() {
      return $('#chat-response').text('Error !1!');
    }
  });
});
