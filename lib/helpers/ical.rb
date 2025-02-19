module IcalHelper
  def event_calendar
    cal = Icalendar::Calendar.new

    items.find_all('/events/*/*.md')
        .select { |x| x[:soon] == nil }
        .each {|i| cal.add_event(event_for(i)) }

    cal.to_ical
  end

  def event_for(item)
    tzid = 'Europe/Brussels'

    e = Icalendar::Event.new
    e.dtstart = Icalendar::Values::DateTime.new item[:time], 'tzid' => tzid
    e.dtend = Icalendar::Values::DateTime.new item[:end], 'tzid' => tzid if item[:end]
    e.summary = item[:title]
    e.description = "#{item[:description]}\n\n#{item.reps[:text].compiled_content}"
    e.location = item[:location]
    e.url = @config[:base_url] + item.path
    e.uid = item.path.sub(/^\/events\//, '').chomp('/').tr('/', '-') + '@zeus.gent'

    e
  end
end
