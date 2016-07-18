sticky_relocate = ->
  window_top = $(window).scrollTop()
  div_top = $('#sticky-anchor').offset().top

  if window_top > div_top
    $('#sticky').addClass('stick')
    $('#sticky-anchor').height($('#sticky').outerHeight())
  else
    $('#sticky').removeClass('stick')
    $('#sticky-anchor').height(0)

$ ->
  $(window).scroll(sticky_relocate)
  sticky_relocate()
