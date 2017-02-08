module IcalHelper
  def event_calendar
    cal = Icalendar::Calendar.new

    items.find_all('/events/*/*.md').each do |i|
      cal.add_event(event_for(i))
    end

    cal.to_ical
  end

  def event_for(item)
    e = Icalendar::Event.new
    e.dtstart = item[:time]
    e.dtend = item[:end] if item[:end]
    e.summary = item[:title]
    e.description = item[:description] + "\n\n" + item.reps[:text].compiled_content
    e.location = item[:location]
    e.url = @config[:base_url] + item.path

    e
  end
end
