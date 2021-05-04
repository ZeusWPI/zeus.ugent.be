module ArchiveHelper
  def academic_years
    # Set.to_a to prevent duplicates
    Set.new(items
              .find_all('/blog/*/*')
              .map { |i| i.identifier.to_s.split('/')[-2] })
              .to_a
       .sort
       .push(@config[:academic_year])
       .uniq
  end

  def academic_years_blog_items
    academic_years.reverse.map { |y| [y, items["/blog/#{y}.html"]] }
  end

  def tag_blog_items
    Set.new(items
      .find_all('/blog/*/*')
      .flat_map { |i| i[:tags] || [] })
    .map{ |y| y.split.map(&:capitalize).join(' ') }
    .to_a
    .sort
    .uniq.map { |y| [y, items["/blog/#{y.gsub(' ', '_')}.html"]]}
  end

  def pretty_year(year)
    year = year.scan(/\d\d/)
    "'#{year[0]} - '#{year[1]}"
  end

  def posts_in_year(y)
    items.find_all("/blog/#{y}/*").sort_by { |x| x[:created_at] }.reverse
  end

  def posts_with_tag(tag)
    items
      .find_all('/blog/*/*')
      .filter{|i| (i[:tags] || []).map{ |t| t.split.map(&:capitalize).join(' ') }.include? tag }
  end

  def posts_in_year_or_with_tag(item)
    if item[:is_yearly]
      posts_in_year(item[:academic_year])
    else
      posts_with_tag(item[:tag])
    end
  end
end
