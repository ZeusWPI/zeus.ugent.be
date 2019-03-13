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
    sponsoring_members_of(@config[:academic_year].to_sym)
  end
end
