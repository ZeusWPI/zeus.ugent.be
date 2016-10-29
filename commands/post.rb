require 'highline/import'
require 'yaml'

usage       'post [options]'
aliases     :p
summary     'Add a new post'
description 'Adds a new post, filling in and validating metadata.'

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
  post_directory = 'content/posts'
  author_file = '.author-information'

  bold_say "Let's make a new post, shall we?"
  bold_say('-' * 20)

  last_entry = "#{post_directory}/#{Dir.entries('content/posts').last}"

  result_hash['title'] = bold_ask 'What will the title be?'

  result_hash['description'] = bold_ask 'Give a description of the event'

  result_hash['author'] = if File.exist? author_file
                            File.read(author_file).chomp
                          else
                            bold_ask 'What is your name?'
                          end

  result_hash['created_at'] = Date.today

  filename = result_hash['title'].downcase.tr(' ', '-').gsub(/[^0-9A-Za-z-]/, '')

  File.open("#{last_entry}/#{filename}.md", 'w') do |file|
    file.write(result_hash.to_yaml + '---')
  end
end
