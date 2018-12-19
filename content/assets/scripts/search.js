var burger, input, input_field, menu;

input_field = document.getElementById('tipue_search_input_field');

input = document.getElementById('tipue_search_input');

input_field.addEventListener('focusin', function() {
  return input.classList.add('focused');
});

input_field.addEventListener('focusout', function() {
  return input.classList.remove('focused');
});

burger = document.getElementsByClassName('navbar-burger')[0];

menu = document.getElementsByClassName('navbar-menu')[0];

burger.addEventListener('click', function() {
  var s;
  s = 'is-active';
  if (menu.classList.contains(s)) {
    menu.classList.remove(s);
  } else {
    menu.classList.add(s);
  }
  if (burger.classList.contains(s)) {
    return burger.classList.remove(s);
  } else {
    return burger.classList.add(s);
  }
});
