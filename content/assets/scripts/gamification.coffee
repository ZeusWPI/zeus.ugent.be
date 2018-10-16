request = new XMLHttpRequest
request.open 'GET', 'https://zeus.ugent.be/game/top4/show.json', true

request.onload = ->
  if request.status >= 200 and request.status < 400
    # Success!
    data = JSON.parse(request.responseText)

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

    el = document.getElementById('gamification-coders')
    el.innerHTML = str
  else
    # We reached our target server, but it returned an error
  return

request.onerror = ->
  # There was a connection error of some sort
  return

request.send()
