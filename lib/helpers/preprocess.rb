module PreprocessHelper
  def required_attrs
    {
      event: {
        time: 'An event item should include the :time attribute, which describes the begin time and date of the event.',
        title: 'The event does not include a :title',
        location: 'The event should include a :location, a textual description',
        locationlink: 'The event does not include a :locationlink, which is a querystring which is used for Google Maps'
      }
    }
  end

  def check_schema(itemtype, item)
    schema = required_attrs[itemtype]

    (schema.keys - item.attributes.keys).each do |key|
      raise "#{item.identifier}: #{schema[key]}"
    end
  end

  def ignore_old_blogposts
    @items.delete_if do |item|
      path = item.identifier.to_s
      next unless path.start_with?('/blog/')
      year = path.gsub(%r{/blog/(\d\d)-\d\d/.*}, '\1').to_i
      year < 16
    end
  end

  def update_blog_attributes
    @items.find_all('/blog/**/*').each do |i|
      raise "#{i.identifier} doesn't have 'created_at'" unless i[:created_at]
      i.update_attributes(
        # Tag all posts with article (for Blogging helper)
        kind: 'article',
        academic_year: i.identifier.to_s[/\d\d-\d\d/],
        created_at: Date.parse(i[:created_at])
      )
    end
  end

  def create_yearly_items(type)
    type = type.to_s
    years = @items.find_all("/#{type.downcase}/*/*").map { |i| i.identifier.to_s[/\d\d-\d\d/] }.uniq

    years.each do |year|
      @items.create(
        '',
        { academic_year: year, title: type },
        "/#{type.downcase}/#{year}.html"
      )
    end

    cur_year_item = @items["/#{type.downcase}/#{@config[:academic_year]}.html"] || @items["/#{type.downcase}/#{years[-1]}.html"]
    cur_year_item.update_attributes(
      navigable: true,
      order: 10
    )
  end

  def convert_event_time_to_timestamps
    @items.find_all('/events/*/*.md').each do |event|
      # HACK: Strings in a format like "2017-10-05T20:45:00+0200" automatically get converted to Time
      event[:time] = event[:time].to_s
      event[:time] = DateTime.parse(event[:time])

      event[:end] = event[:end].to_s if event[:end]
      event[:end] = DateTime.parse(event[:end]) if event[:end]
    end
  end

  def add_report_metadata
    @items.find_all('/about/verslagen/*/*').each do |report|
      report[:academic_year] = report.identifier.to_s.split('/')[-2]
      report[:date] = Date.strptime(report.identifier.without_ext.split('/').last)
    end
  end
end
