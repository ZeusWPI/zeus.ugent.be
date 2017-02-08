module PreprocessHelper
  def ignore_old_blogposts
    @items.delete_if do |item|
      next unless item.identifier.to_s.start_with?('/blog/')
      !item.identifier.to_s.start_with?('/blog/16-17/')
    end
  end

  def update_blog_attributes
    @items.find_all('/blog/**/*').each do |i|
      year_str = %r{/(\d\d)-\d\d/}.match(i.identifier).captures[0]

      attr_hash = {
        # Tag all posts with article (for Blogging helper)
        kind: 'article',
        academic_year: year_str.to_i
      }

      i.update_attributes(attr_hash)
    end
  end

  def create_blog_items
    # academic_years is defined in archives.rb
    academic_years.each do |year|
      @items.create(
        '',
        { academic_year: year, title: 'Blog' },
        "/blog/#{year}-#{year + 1}.html"
      )
    end

    academic_years_items[academic_years.max].update_attributes(
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
