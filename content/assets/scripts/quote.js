$(function() {
  return $.getJSON('./quotes.json', function(data) {
    var quote;
    quote = data[Math.floor(Math.random() * data.length)];
    return $('#quote').append("<h3>" + quote.title + "</h3><p>" + quote.description + "</p>");
  });
});
