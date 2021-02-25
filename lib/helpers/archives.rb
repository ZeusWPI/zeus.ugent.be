module ArchiveHelper
  def academic_years
    # Set.to_a to prevent duplicates
    Set.new(items
              .find_all('/bloch/*/*')
              .map { |i| i.identifier.to_s.split('/')[-2] })
              .to_a
       .sort
       .push(@config[:academic_year])
       .uniq
  end

  def academic_years_bloch_items
    academic_years.reverse.map { |y| [y, items["/bloch/#{y}.html"]] }
  end

  def tag_bloch_items
    Set.new(items
      .find_all('/bloch/*/*')
      .flat_map { |i| i[:tags] || [] })
    .to_a
    .sort
    .uniq.map { |y| [y, items["/bloch/#{y.gsub(' ', '_')}.html"]]}
  end

  def pretty_year(year)
    year = year.scan(/\d\d/)
    "'#{year[0]} - '#{year[1]}"
  end

  def posts_in_year(y)
    items.find_all("/bloch/#{y}/*").sort_by { |x| x[:created_at] }.reverse
  end

  def posts_with_tag(tag)
    items
      .find_all('/bloch/*/*')
      .filter{|i| (i[:tags] || []).include? tag }
  end

  def posts_in_year_or_with_tag(item)
    if item[:is_yearly]
      posts_in_year(item[:academic_year])
    else
      posts_with_tag(item[:tag])
    end
  end
end
