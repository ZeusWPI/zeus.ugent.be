$ ->
  $.getJSON './quotes.json', (data) ->
    quote = data[Math.floor(Math.random()*data.length)]
    $('#quote').append("<h3>#{quote.title}</h3><p>#{quote.description}</p>")
