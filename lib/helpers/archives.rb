module ArchiveHelper
  def academic_years
    Set.new(items.find_all('/blog/*/*').map { |i| i.identifier.to_s[/\d\d-\d\d/] }).to_a
  end

  def academic_years_items
    academic_years.reverse.map { |y| [y, items["/blog/#{y}.html"]] }
  end

  def pretty_year(year)
    year = year.scan(/\d\d/)
    "'#{year[0]} - '#{year[1]}"
  end

  def posts_in_year(y)
    items.find_all("/blog/#{y}/*").sort_by { |x| x[:created_at] }.reverse
  end
end
