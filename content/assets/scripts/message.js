const form = $("#cammieForm");
const formName = $('#cammieFormName');
const formMessage = $('#cammieFormMessage');
const formButton = form.find('button[type="submit"]');
const responseError = $("#cammieFormResponseError");
const responseSuccess = $("#cammieFormResponseSuccess");
const modal = $("#cammieFormModal");
const modalName = $("#cammieModalName");
const modalCancel = $("#cammieModalCancel");

$("#cammieForm").submit((e) => {
  e.preventDefault();
  formButton.addClass("is-loading");

  if (!formName.val() || formName.val() === "") {
    modal.addClass("is-active");
    return
  }

  return $.ajax({
    url: "https://kelder.zeus.ugent.be/messages/",
    contentType: "text/plain",
    type: "POST",
    headers: formName.val() ? { "X-Username": formName.val()} : {},
    data: formMessage.val(),
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

$("#cammieModalSend").on("click", e => {
  modal.removeClass("is-active");
  formName.val(modalName.val() || "-");
  modal.removeClass("is-active");
  form.submit();
});

$("#cammieModalCancel").on("click", e => {
  modal.removeClass("is-active");
});
