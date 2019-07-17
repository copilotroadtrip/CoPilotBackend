class LegInfo
  attr_reader :time, :distance

  def initialize(time_in_seconds, distance_in_meters)
    @time = parse_time(time_in_seconds)
    @distance = parse_distance(distance_in_meters)
  end

  def json_with_id(index)
    {
      distance: "#{distance.round} mi",
      duration_in_hours: time,
      id: index
    }
  end

  private
  def parse_time(seconds)
    seconds / 3600.0
  end

  def parse_distance(meters)
    meters / 1609.344
  end


end
