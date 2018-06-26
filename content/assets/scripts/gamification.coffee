  $.getJSON 'https://zeus.ugent.be/game/top4/show.json', (data) ->
    str = "<table>"
    for x in data
      str += """
        <tr>
          <td class="picture">
            <img class="coder-picture" src="#{x.avatar_url}">
          </td>
          <td class="name">
            <a class="coder-name" href="#{x.github_url}">#{x.github_name}</a>
          </td>
          <td class="score">
            #{x.score}
          </td>
        </tr>
      """
    str += "</table>"

    $('#gamification-coders').html(str)
