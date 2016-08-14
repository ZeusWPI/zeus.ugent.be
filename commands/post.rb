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
  ask "<%= color %(#{str}), :bold %>", *args
end

run do |_opts, _args, _cmd|
  result_hash = {}

  bold_say "Let's make a new post, shall we?"
  bold_say('-' * 20)

  puts

  bold_say 'What kind of post will it be?'

  type = choose do |menu|
    default = :event

    menu.prompt = "(default #{default})"
    menu.choice :blog
    menu.choice :event
    menu.default = default
  end

  puts

  result_hash['title'] = bold_ask 'What will the title be?'

  puts

  result_hash['time'] = bold_ask 'When will the event take place?', Date

  puts

  result_hash['banner'] = bold_ask 'Supply a link to the banner of the event, please' if type == :event

  puts result_hash.to_yaml
end
