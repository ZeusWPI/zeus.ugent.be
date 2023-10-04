const form = $("#cammieForm");
const formName = form.find('input[name="name"]');
const formMessage = form.find('input[name="message"]');
const formButton = form.find('button[type="submit"]');
const responseError = $("#cammieFormResponseError");
const responseSuccess = $("#cammieFormResponseSuccess");

const socket = io("https://kelder.zeus.ugent.be");

socket.on('replymessage', function(obj) {
    alert("Kelder says: " + obj['message']);
})

$("#cammieForm").submit((e) => {
  e.preventDefault();
  formButton.addClass("is-loading");
  socket.timeout(4000).emit("message",{username: formName.val(), message: formMessage.val()},(err,_) => {
    if (err) {
      responseSuccess.addClass("is-hidden");
      responseError.removeClass("is-hidden");
      responseError.text("Something went wrong, please try again later.");
    } else {
      responseError.addClass("is-hidden");
      responseSuccess.removeClass("is-hidden");
      responseSuccess.text("Message has been successfully sent.");
      formMessage.val("");
    }
  })
});
