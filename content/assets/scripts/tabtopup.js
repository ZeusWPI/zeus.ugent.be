function regenerateQR() {
  let username_field = document.getElementById('tabtopup-username');
  let amount_field = document.getElementById('tabtopup-amount');
  let qr_container = document.getElementById("tabtopup-qrcode");
  let amountUnparsed = amount_field.value;
  let username = username_field.value;
  username_field.classList.remove('is-danger');
  amount_field.classList.remove('is-danger');

  qr_container.textContent = '';

  let message_container = document.getElementById('tabtopup-message');
  if (username == '') {
    message_container.textContent = 'Please fill in username';
    username_field.classList.add('is-danger');
    return;
  }
  else if (!(/^[a-z0-9A-Z\-_.]+$/.test(username))) {
    message_container.textContent = 'Are you sure that ' + username + ' is your username? Most usernames only contain letters and numbers. If you\'re not sure what your username is, feel free to contact the board.';
    username_field.classList.add('is-danger');
    return;
  } else if (amountUnparsed == '') {
    message_container.textContent = 'Please fill in amount';
    amount_field.classList.add('is-danger');
    return;
  } else {
    message_container.textContent = '';
  }

  let amount =  parseFloat(document.getElementById('tabtopup-amount').value.replace(',', '.'));
  message_container.textContent = username + ' will top up for ' + amount.toFixed(2) + ' euro.';

  let message = 'TAB ' + username;
  if (message.length >= 80) {
    message_container.textContent = 'Username too long.';
    username_field.classList.add('is-danger');
    return;
  }
  if (amount <= 0) {
    message_container.textContent = 'Amount should be at least 0.01 euro (but preferably more of course)';
    amount_field.classList.add('is-danger');
    return;
  }

  let qr_data = generateQrCode({
    name: 'Zeus WPI',
  	iban: document.getElementById('banknumber').textContent,
  	amount: amount,
  	unstructuredReference: message,
  	information: 'Zeus WPI Tab',
  });
  new QRCode(qr_container, {
    text: qr_data,
    width: 256,
    height: 256,
    correctLevel: QRCode.CorrectLevel.M
  });
  return;
}

window.onload = function() {
  document.getElementById('tab-qr-button').addEventListener('click', function(event) {
    event.preventDefault();
    let modal = document.querySelector('.modal');
    let html = document.querySelector('html');
    modal.classList.add('is-active');
    html.classList.add('is-clipped');

    modal.querySelector('.modal-background').addEventListener('click', function(e) {
      e.preventDefault();
      modal.classList.remove('is-active');
      html.classList.remove('is-clipped');
    });
  });
  document.getElementById('tabtopup-username').addEventListener('input', regenerateQR);
  document.getElementById('tabtopup-amount').addEventListener('input', regenerateQR);
  regenerateQR();
}
