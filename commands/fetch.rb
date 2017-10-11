# frozen_string_literal: true

require 'net/http'
require 'json'

usage       'fetch [facebook event id]'
aliases     :f
summary     'Fetch an event from facebook'
description 'Fetch an event from facebook'

run do |_opts, args, _cmd|
  fb_token = File.read('.fb_token')
  uri = URI("https://graph.facebook.com/v2.10/#{args[0]}?fields=cover,name,description,start_time,place,end_time&access_token=#{fb_token}")
  o = JSON.parse(Net::HTTP.get(uri))

  puts <<~EOS
  ---
  title: "#{o['name']}"
  time: #{o['start_time']}
  location: #{o['place']['name']}
  end: #{o['end_time']}
  banner: #{o['cover']['source']}
  ---

  #{o['description']}
  EOS
end
