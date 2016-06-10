$.get 'https://api.github.com/orgs/ZeusWPI/events', (data) ->
  for e in data
    console.log e
    $('#github-feed ul').append(
      $('<li />').append(
        $('<img />',
          style: 'width: 50px;',
          src: e.actor.avatar_url
        )
      ).append e.type
    )
