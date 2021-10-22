require 'tzinfo'

$tz = TZInfo::Timezone.get('Europe/Brussels')

module PreprocessHelper
  def required_attrs
    {
        event: {
            time: 'An event item should include the :time attribute, which describes the begin time and date of the event.',
            title: 'The event does not include a :title',
            location: 'The event should include a :location, a textual description',
        },
        privacy: {
            status: 'A privacy item must include the status of the project'
        }
    }
  end

  def predefined_locations
    {
      '$kelder' => 'Zeus WPI, Gent',
      '$s9' => 'S9, Gent',
      '$therminal' => 'De Therminal, Gent'
    }
  end

  def allowed_privacy_status
    %w(additional general processor development)
  end

  def check_schema(itemtype, item)
    schema = required_attrs[itemtype]

    (schema.keys - item.attributes.keys).each do |key|
      raise "#{item.identifier}: #{schema[key]}"
    end

    if itemtype == :privacy && !allowed_privacy_status.include?(item.attributes[:status])
      raise "status must be one of #{allowed_privacy_status}, got #{item.attributes[:status]} on #{item[:filename]}"
    end
  end

  def ignore_old_content(*paths)
    paths.each do |path|
      years_with_content = @items.find_all("/#{path}/**/*").map { |it| it.identifier.to_s.match(%r{/(\d\d-\d\d)/})[1] }
      latest_years_with_content = years_with_content.last(2)

      latest_years = latest_years_with_content + [@config[:academic_year]]
      @items.delete_if do |item|
        next unless item.identifier.match?(%r{^/#{path}/})
        year = item.identifier.to_s.match(%r{/(\d\d-\d\d)/})[1]
        !latest_years.include?(year)
      end
    end
  end

  def update_blog_attributes
    @items.find_all('/blog/**/*.md').each do |i|
      raise "#{i.identifier} doesn't have 'created_at'" unless i[:created_at]
      i.update_attributes(
        # Tag all posts with article (for Blogging helper)
        kind: 'article',
        academic_year: i.identifier.to_s[/\d-\d/],
        created_at: Date.parse(i[:created_at])
      )
    end
  end

  def create_yearly_items(type)
    type = type.to_s
    years = @items.find_all("/#{type.downcase}/*/*")
      .map { |i| i.identifier.to_s[/\d\d-\d\d/] }
      .push(@config[:academic_year])
      .uniq

    years.each do |year|
      @items.create(
        '',
        { academic_year: year, title: type, is_yearly: true },
        "/#{type.downcase}/#{year}.html"
      )
    end

    cur_year_item = @items["/#{type.downcase}/#{@config[:academic_year]}.html"] || @items["/#{type.downcase}/#{years[-1]}.html"]
    cur_year_item.update_attributes(
      navigable: true,
      order: 10
    )

    @items.create(
      '',
      { academic_year: @config[:academic_year], title: type, is_yearly: true },
      "/#{type.downcase}/index.html"
    )
  end

  def create_tagly_items(type)
    type = type.to_s
    tags = @items.find_all("/#{type.downcase}/*/*")
      .flat_map { |i| i[:tags] || [] }
      .uniq

    tags.each do |tag|
      @items.create(
        '',
        { tag: tag, title: type, is_yearly: false },
        "/#{type.downcase}/#{tag.gsub(' ', '_')}.html"
      )
    end
  end

  def convert_event_time_to_timestamps
    @items.find_all('/events/*/*.md').each do |event|
      # HACK: Strings in a format like "2017-10-05T20:45:00+0200" automatically get converted to Time
      event[:time] = event[:time].to_s
      event[:time] = DateTime.parse(event[:time])
      t = event[:time]
      event[:time] = $tz.local_datetime(t.year, t.month, t.day, t.hour, t.minute, t.second)

      if event[:end]
        event[:end] = event[:end].to_s
        event[:end] = DateTime.parse(event[:end])
        t = event[:end]
        event[:end] = $tz.local_datetime(t.year, t.month, t.day, t.hour, t.minute, t.second)
      end
    end
  end

  def convert_locations
    @items.find_all('/events/*/*.md').each do |event|
      location_link = event[:locationlink]&.downcase&.strip
      if location_link&.start_with?('$') && !predefined_locations.key?(location_link)
        raise "unknown location variable #{location_link}, must be one of #{predefined_locations.keys}"
      end
      event[:locationlink] = predefined_locations.fetch(location_link, event[:locationlink])
    end
  end

  def convert_tags(type)
    type = type.to_s
    @items.find_all("/#{type.downcase}/*/*").each do |item|
      if item.key?(:tags)
        item[:tags] = item[:tags]
          .map{ |tag| tag.split.map(&:capitalize).join(' ') }
      end
    end
  end

  def add_report_metadata
    @items.find_all('/about/verslagen/*/*').each do |report|
      report[:academic_year] = report.identifier.to_s.split('/')[-2]
      report[:date] = Date.strptime(report.identifier.without_ext.split('/').last)
    end
  end

  def update_project_item(projects, project)
    id = project.identifier.without_ext.split('/')[-1]
    if projects.key?(id.to_sym)
      projects[id.to_sym].each do |key, value|
        project[key] = value
      end
      project[:id] = id
    end
  end

  def add_project_metadata
    projects = data_from(:projecten)
    all_privacy_items.each do |project|
      update_project_item(projects, project)
    end
    all_project_items.each do |project|
      update_project_item(projects, project)
    end
  end
end
