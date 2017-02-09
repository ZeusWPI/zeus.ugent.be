module TimeHelper
  def christmastime?
    timehelper([[Time.new(Time.now.year, 12, 6), Time.new(Time.now.year, 12, 31)]])
  end

  def studytime?
    year = Time.now.year
    timehelper([
                 [Time.new(year, 12, 14), Time.new(year, 12, 31)],
                 [Time.new(year, 1, 1), Time.new(year, 2, 7)],
                 [Time.new(year, 5, 15), Time.new(year, 6, 30)],
                 [Time.new(year, 8, 5), Time.new(year, 9, 10)]
               ])
  end

  def timehelper(ranges)
    ranges.any? { |range| periodhelper(*range) }
  end

  def periodhelper(startdate, enddate)
    Time.now.between?(startdate, enddate)
  end
end
