$.getJSON 'https://zeus.ugent.be/game/top4/show.json', (data) ->
  $('#top-coder-name').text(data[0].github_name)

$.get 'https://api.github.com/orgs/ZeusWPI/events', (data) ->
  for e in data
    $('#github-feed ul').append(
      $('<li />').append(
        $('<img />',
          style: 'width: 50px;',
          src: e.actor.avatar_url
        )
      ).append e.type
    )
