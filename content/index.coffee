$.getJSON 'https://zeus.ugent.be/game/top4/show.json', (data) ->
  $('#top-coder-name').text(data[0].github_name)
