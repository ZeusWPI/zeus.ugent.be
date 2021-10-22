require 'tzinfo'

$tz = TZInfo::Timezone.get('Europe/Brussels')

module TimeHelper
  def christmastime?
    timehelper([[Time.new($tz.now.year, 12, 6), Time.new($tz.now.year, 12, 31)]])
  end

  def studytime?
    year = $tz.now.year
    timehelper([
                 [Time.new(year, 12, 14), Time.new(year, 12, 31)],
                 [Time.new(year, 1, 1), Time.new(year, 2, 7)],
                 [Time.new(year, 5, 15), Time.new(year, 6, 30)],
                 [Time.new(year, 8, 5), Time.new(year, 9, 10)]
               ])
  end

  def new_member_time?
    year = $tz.now.year
    timehelper([[Time.new(year, 9, 20), Time.new(year, 10, 15)]])
  end

  def timehelper(ranges)
    ranges.any? { |range| periodhelper(*range) }
  end

  def periodhelper(startdate, enddate)
    $tz.now.between?(startdate, enddate)
  end
end
