module AboutHelper
  def bestuur_of(year)
    data_from(:bestuur)[year]
  end

  def current_bestuur
    bestuur_of(@config[:academic_year].to_sym)
  end
end
