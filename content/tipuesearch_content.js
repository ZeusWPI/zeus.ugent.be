var tipuesearch = { "pages": [
  <% articles.each do |e| %>
    {
      "title": "<%= e[:title] %>",
      "url": "<%= url_for(e) %>",
      "text": "<%= excerptize(e.reps[:text].compiled_content, length: 200).gsub(/\n/, ' ') %>",
      "tags": ""
    },
  <% end %>
]};
