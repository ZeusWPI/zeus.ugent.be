module IcalHelper
  def event_calendar
    cal = Icalendar::Calendar.new

    items.find_all('/events/*/*.md').each do |i|
      cal.add_event(event_for(i))
    end

    cal.to_ical
  end

  def event_for(item)
    event = Icalendar::Event.new
    event.dtstart = item[:time]
    event.summary = 'A great event!'

    event
  end
end
