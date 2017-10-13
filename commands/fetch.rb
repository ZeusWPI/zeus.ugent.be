# frozen_string_literal: true

require 'net/http'
require 'json'

usage       'fetch [facebook event id]'
aliases     :f
summary     'Fetch an event from facebook'
description 'Fetch an event from facebook'

run do |_opts, args, _cmd|
  fb_token = File.read('.fb_token')
  event_id = args[0]
  uri = URI("https://graph.facebook.com/v2.10/#{event_id}?fields=cover,name,description,start_time,place,end_time&access_token=#{fb_token}")
  o = JSON.parse(Net::HTTP.get(uri))
  puts <<~EOS
  ---
  title: "#{o['name']}"
  description: #Fill in
  time: #{o['start_time']}
  end: #{o['end_time']}
  location: #{o['place']['name']}
  banner: #{o['cover']['source']}
  created_at: #Fill in
  facebook: 'https://www.facebook.com/events/#{event_id}/'
  ---

  #{o['description']}
  EOS
end
