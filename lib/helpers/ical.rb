module IcalHelper
  def event_calendar
    cal = Icalendar::Calendar.new

    events = items.find_all('/posts/**/*').map { |i| event_for(i) }
    events.each { |e| cal.add_event(e) }

    cal.to_ical
  end

  def event_for(i)
    event = Icalendar::Event.new
    event.dtstart = Date.parse(i[:time])
    event.summary = 'A great event!'

    event
  end
end
