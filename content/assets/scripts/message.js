const form = $("#cammieForm");
const formName = $('#cammieFormName');
const formMessage = $('#cammieFormMessage');
const formButton = form.find('button[type="submit"]');
const responseError = $("#cammieFormResponseError");
const responseSuccess = $("#cammieFormResponseSuccess");
const modal = $("#cammieFormModal");
const modalName = $("#cammieModalName");
const modalCancel = $("#cammieModalCancel");

const socket = io("https://kelder.zeus.ugent.be");

socket.on('replymessage', function(obj) {
    alert("Kelder says: " + obj['message']);
})

$("#cammieForm").submit((e) => {
  e.preventDefault();
  formButton.addClass("is-loading");
  
  if (!formName.val() || formName.val() === "") {
    modal.addClass("is-active");
    return
  }
  
  socket.timeout(3000).emit("message",{username: formName.val(), message: formMessage.val()},(err,_) => {
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
    formButton.removeClass("is-loading");
  })
});

$("#cammieModalSend").on("click", e => {
  modal.removeClass("is-active");
  formName.val(modalName.val() || "-");
  modal.removeClass("is-active");
  form.submit();
});

$("#cammieModalCancel").on("click", e => {
  modal.removeClass("is-active");
});
