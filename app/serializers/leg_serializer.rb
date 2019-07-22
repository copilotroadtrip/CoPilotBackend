class LegSerializer
  attr_reader :time, :distance

  ### THIS SHOULD PROBSBLY BE DEPRECATED
  ### Currently this is only used in the initial POST response
  ### But 'trip_legs' already has a `to_json`
  def initialize(time, distance, trip_id, sequence_number)
    @time = time
    @distance = meters_to_miles(distance)
    @trip_id = trip_id
    @sequence_number = sequence_number
  end

  def self.from_json(leg_info, trip_id, sequence_number)
    time = time_to_hours(leg_info['duration']['value'])
    distance = leg_info['distance']['value']
    self.new(time, distance, trip_id, sequence_number)
  end

  def self.from_database(trip_leg)
    self.new(trip_leg.duration, trip_leg.distance, trip_leg.trip_id, trip_leg.sequence_number)

  end

  def to_json
    {
      distance: "#{@distance} mi",
      duration_in_hours: @time,
      sequence_number: @sequence_number,
    }
  end

  private
  def self.time_to_hours(seconds)
    seconds / 3600.0
  end

  def meters_to_miles(meters)
    meters / 1609.344
  end


end
