$ ->
  $.getJSON 'https://zeus.ugent.be/game/top4/show.json', (data) ->
    str = "<ol>"
    for x in data
      str += "<li><a href=\"#{x.github_url}\">#{x.github_name}</a> (#{x.score} Z$)</li>"
    str += "</ol>"

    $('#gamification-coders').html(str)
