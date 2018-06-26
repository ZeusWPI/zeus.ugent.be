input_field = document.getElementById('tipue_search_input_field')
input = document.getElementById('tipue_search_input')

input_field.addEventListener 'focusin', ->
  input.classList.add('focused')

input_field.addEventListener 'focusout', ->
  input.classList.remove('focused')

burger = document.getElementsByClassName('navbar-burger')[0]
menu = document.getElementsByClassName('navbar-menu')[0]

burger.addEventListener 'click', ->
  s = 'is-active'
  if menu.classList.contains(s) then menu.classList.remove(s) else menu.classList.add(s)
  if burger.classList.contains(s) then burger.classList.remove(s) else burger.classList.add(s)
