var request;

request = new XMLHttpRequest;

request.open('GET', 'https://gamification.pratchett.zeus.gent/top4.json', true);

request.onload = function() {
  var data, el, i, len, str, x;
  if (request.status >= 200 && request.status < 400) {
    data = JSON.parse(request.responseText);
    str = "<table>";
    for (i = 0, len = data.length; i < len; i++) {
      x = data[i];
      str += "<tr>\n    <td class=\"picture\">\n    <img class=\"coder-picture\" src=\"" + x.avatar_url + "\">\n    </td>\n    <td class=\"name\">\n    <a class=\"coder-name\" href=\"" + x.github_url + "\">" + x.github_name + "</a>\n    </td>\n    <td class=\"score\">\n    " + x.score + "\n    </td>\n</tr>";
    }
    str += "</table>";
    el = document.getElementById('gamification-coders');
    el.innerHTML = str;
  } else {

  }
};

request.onerror = function() {};

request.send();
