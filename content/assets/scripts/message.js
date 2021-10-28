const form = $("#cammieForm");
const formMessage = form.find('input[name="message"]');
const formButton = form.find('button[type="submit"]');
const responseError = $("#cammieFormResponseError");
const responseSuccess = $("#cammieFormResponseSuccess");

$("#cammieForm").submit((e) => {
  e.preventDefault();
  formButton.addClass("is-loading");

  return $.ajax({
    url: "https://kelder.zeus.ugent.be/messages/",
    contentType: "text/plain",
    type: "POST",
    data: form.find('input[name="message"]').val(),
    success() {
      responseError.addClass("is-hidden");
      responseSuccess.removeClass("is-hidden");
      responseSuccess.text("Message has been successfully sent.");
      formMessage.val("");
    },
    error() {
      responseSuccess.addClass("is-hidden");
      responseError.removeClass("is-hidden");
      responseError.text("Something went wrong, please try again later.");
    },
    complete() {
      formButton.removeClass("is-loading");
    },
  });
});
