module PreprocessHelper
  def ignore_old_blogposts
    @items.delete_if do |item|
      next unless item.identifier.to_s.start_with?('/blog/')
      !item.identifier.to_s.start_with?('/blog/16-17/')
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

    @items["/#{type.downcase}/#{years[-1]}.html"].update_attributes(
      navigable: true,
      order: 10
    )
  end

  def convert_event_time_to_timestamps
    all_events.each do |event|
      event[:time] = DateTime.parse(event[:time])
      event[:end] = DateTime.parse(event[:end]) if event[:end]
    end
  end
end
