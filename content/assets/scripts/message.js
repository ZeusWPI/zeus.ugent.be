const form = $("#cammieForm");
const formName = $("#cammieFormName");
const formMessage = $("#cammieFormMessage");
const formButton = form.find('button[type="submit"]');
const responseError = $("#cammieFormResponseError");
const responseSuccess = $("#cammieFormResponseSuccess");
const modal = $("#cammieFormModal");
const modalName = $("#cammieModalName");

const socket = new WebSocket("ws://kelder.zeus.ugent.be/ws/messages");

socket.onmessage = function (ev) {
  let frame;
  try {
    frame = JSON.parse(ev.data);
  } catch {
    return;
  }

  if (frame.event === "replymessage") {
    const obj = frame.data || {};
    const user = obj.name ? obj.name : "Kelder";
    alert(`${user} says: ${obj.message}`);
  }

  if (frame.event === "ack") {
    responseError.addClass("is-hidden");
    responseSuccess.removeClass("is-hidden");
    responseSuccess.text("Message has been successfully sent.");
    formMessage.val("");
    formButton.removeClass("is-loading");
  }

  if (frame.event === "error") {
    responseSuccess.addClass("is-hidden");
    responseError.removeClass("is-hidden");
    responseError.text(frame?.data?.message || "Something went wrong.");
    formButton.removeClass("is-loading");
  }
};

form.on("submit", function (e) {
  e.preventDefault();
  formButton.addClass("is-loading");

  if (!formName.val()) {
    modal.addClass("is-active");
    formButton.removeClass("is-loading");
    return;
  }

  socket.send(JSON.stringify({
    event: "message",
    data: {
      username: formName.val(),
      message: formMessage.val()
    }
  }));
});

$("#cammieModalSend").on("click", function () {
  modal.removeClass("is-active");
  formName.val(modalName.val() || "-");
  form.submit();
});

$("#cammieModalCancel").on("click", function () {
  modal.removeClass("is-active");
});
