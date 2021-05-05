# frozen_string_literal: true

require 'uri'

module EventsHelper
  def all_events(year = nil, soon = nil)
    items_ = if year
               @items.find_all("/events/#{year}/*.md")
             else
               @items.find_all('/events/*/*.md')
             end

    items_.select { |x| x[:soon] == soon }.sort_by { |x| x[:time] }
  end

  def tag_event_items
    Set.new(items
      .find_all('/events/*/*')
      .flat_map { |i| i[:tags] || [] })
    .map{ |y| y.split.map(&:capitalize).join(' ') }
    .to_a
    .sort
    .uniq.map { |y| [y, items["/events/#{y.gsub(' ', '_')}.html"]]}
  end

  def all_events_by_tag(tag = nil, soon = nil)
    @items.find_all('/events/*/*.md')
      .filter { |i| (i[:tags] || []).include? tag }
      .select { |x| x[:soon] == soon }
      .sort_by { |x| x[:time] }
  end

  def soon_events
    all_events(nil, true)
  end

  def upcoming_events(year = nil)
    all_events(year).reject { |x| x[:time] <= Date.today }
  end

  def upcoming_events_in_year_or_tag(item)
    if item[:is_yearly]
      upcoming_events(item[:academic_year])
    else
      all_events_by_tag(item[:tag]).reject { |x| x[:time] <= Date.today }
    end
  end

  def past_events(year = nil)
    all_events(year).reject { |x| x[:time] > Date.today }.reverse
  end

  def past_events_in_year_or_tag(item)
    if item[:is_yearly]
      past_events(item[:academic_year])
    else
      all_events_by_tag(item[:tag]).reject { |x| x[:time] > Date.today }.reverse
    end
  end

  def academic_years_event_items
    items.find_all('/events/*').reject { |e| e[:academic_year].nil? }.map { |e| [e[:academic_year], e] }.sort_by(&:first).reverse
  end

  def grouped_events
    @items.find_all('/events/*/*/main.md')
  end

  def previous_events
    all_events.reverse[(upcoming_events.length)..]
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
end
