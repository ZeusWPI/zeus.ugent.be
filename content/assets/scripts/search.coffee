$ ->
  $('#tipue_search_input_field').focusin ->
    $('#tipue_search_input').addClass("focused")

  $('#tipue_search_input_field').focusout ->
    $('#tipue_search_input').removeClass("focused")
