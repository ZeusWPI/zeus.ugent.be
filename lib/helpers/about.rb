module AboutHelper
  def bestuur_of(year)
    data_from(:bestuur)[year]
  end

  def current_bestuur
    bestuur_of(@config[:academic_year].to_sym)
  end

  def sponsoring_members_of(year)
    data_from(:supporting_members)[year]
  end

  def current_sponsoring_members
    sponsoring_members_of(@config[:sponsoring_members_year])
  end

  def sponsors_of(year)
    data_from(:sponsors)[year]
  end

  def current_sponsors
    sponsors_of(@config[:sponsors_year])
  end

  def all_bestuur
    data_from(:bestuur).sort_by(&method(:academic_year_sort)).reverse.to_h
  end

  def academic_year_string(year)
    first, second = year.to_s.split('-')
    "#{to_full_year(first)} – #{to_full_year(second)}"
  end

  def academic_year_sort(year)
    first, _ = year.to_s.split('-')
    to_full_year(first).to_i
  end

  def to_full_year(year)
    (year.to_i < 90) ? "20#{year}" : "19#{year}"
  end

  def to_HTML(text)
    text.gsub("<", "&lt;").gsub(">", "&gt;").gsub("\n", "<br>");
  end
end
