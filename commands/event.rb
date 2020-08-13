require 'highline/import'
require 'yaml'

usage       'event [options]'
aliases     :e
summary     'Add a new event'
description 'Adds a new event, filling in and validating metadata.'

def bold_say(str)
  say "<%= color %(#{str}), :bold %>"
end

def bold_ask(str, *args)
  res = ask "<%= color %(#{str}), :bold %>", *args
  puts
  res
end

run do |_opts, _args, _cmd|
  result_hash = {}
  post_directory = 'content/events'
  author_file = '.author-information'

  bold_say "Let's make a new event, shall we?"
  bold_say('-' * 20)

  last_entry = "#{post_directory}/#{Dir.entries('content/events').last}"

  result_hash['title'] = bold_ask 'What will the title be?'

  result_hash['description'] = bold_ask 'Give a description of the event'

  result_hash['author'] = if File.exist? author_file
                            File.read(author_file).chomp
                          else
                            bold_ask 'What is your name?'
                          end

  result_hash['created_at'] = Date.today

  result_hash['time'] = DateTime.parse(bold_ask('When will the event start? (Use a format Ruby understands)')).to_s

  result_hash['end'] = DateTime.parse(bold_ask('When will the event end? (Use a format Ruby understands)')).to_s

  result_hash['location'] = bold_ask 'Where will the event take place? (Textual description)'

  result_hash['locationlink'] = bold_ask 'Where will the event take place? (Something OSM can find or $kelder, $s9 or $therminal)'

  filename = result_hash['title'].downcase.tr(' ', '-').gsub(/[^0-9A-Za-z-]/, '')

  File.open("#{last_entry}/#{filename}.md", 'w') do |file|
    file.write(result_hash.to_yaml + '---')
  end
end
