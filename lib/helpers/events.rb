require 'uri'
module EventsHelper
  def all_events
    @items.find_all('/events/*/*') + grouped_events
  end

  def grouped_events
    @items.find_all('/events/*/*/main.md')
  end

  def sub_events(grouped_event)
    if grouped_event.identifier =~ /main.md/
      query = grouped_event.identifier.to_s.split('/')[0..-2].join('/') + '/*'
      @items.find_all(query).reject do |i|
        i.identifier =~ /main.md/
      end
    else
      []
    end
  end

  def locationlink(location)
    "https://www.google.com/maps/embed/v1/place?key=AIzaSyBDTmw7LtDG28o9QjCnNucAJv2zTZpLjJU&q=#{URI.escape(location)}" if location
  end
end
