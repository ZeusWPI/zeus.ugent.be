module ArchiveHelper
  def academic_years
    academic_years = Set.new

    items.find_all('/posts/**/*').each do |i|
      academic_year = %r{/(\d\d)-\d\d/}.match(i.identifier).captures[0]
      academic_years << academic_year.to_i
    end

    academic_years
  end

  def academic_years_items
    academic_years.to_a.reverse.map { |y| [y, items["/archives/#{y}-#{y + 1}.html"]] }.to_h
  end

  def pretty_year(year)
    "'#{year} - '#{year + 1}"
  end

  def posts_in_year(academic_year)
    items.find_all('/posts/**/*').select do |post|
      post[:academic_year] == academic_year
    end
  end
end
