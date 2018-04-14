$('#tipue_search_input_field').on 'focusin', ->
  $('#tipue_search_input').addClass("focused")

$('#tipue_search_input_field').on 'focusout', ->
  $('#tipue_search_input').removeClass("focused")

$('.navbar-burger').on 'click', ->
  $('.navbar-menu').toggleClass('is-active')
  $('.navbar-burger').toggleClass('is-active')
