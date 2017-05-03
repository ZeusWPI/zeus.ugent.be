$('#tipue_search_input_field').on 'focusin', ->
  $('#tipue_search_input').addClass("focused")

$('#tipue_search_input_field').on 'focusout', ->
  $('#tipue_search_input').removeClass("focused")

$('.nav-toggle').on 'click', ->
  $('.nav-menu').toggleClass('is-active')
  $('.nav-toggle').toggleClass('is-active')
