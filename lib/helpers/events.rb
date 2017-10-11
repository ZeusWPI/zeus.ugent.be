# frozen_string_literal: true

require 'uri'

module EventsHelper
  def all_events(year = nil)
    items_ = if year
               @items.find_all("/events/#{year}/*.md")
             else
               @items.find_all('/events/*/*.md')
             end

    items_.sort_by { |x| x[:time] }
  end

  def upcoming_events(year = nil)
    all_events(year).reject { |x| x[:time] <= Date.today }
  end

  def past_events(year = nil)
    all_events(year).reject { |x| x[:time] > Date.today }.reverse
  end

  def academic_years_event_items
    items.find_all('/events/*').map { |e| [e[:academic_year], e] }.sort_by(&:first)
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
