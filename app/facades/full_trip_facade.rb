class FullTripFacade
  def initialize(trip)
    @trip = trip
  end

  def response
    {
      data:
        {
          places: places,
          legs: legs
        }
    }
  end

  def places
    trip.pois.map do |poi|
      # This is only current weather,
      # will need to update with timing between pois
      place = PoiSerializer.new(poi).to_json_with_timing(0)

      sequence_number = TripPoi.find_by(trip: trip, poi: poi).sequence_number
      place.merge({sequence_number: sequence_number})
    end
  end

  def legs
    trip.trip_legs.map do |trip_leg|
      trip_leg.to_json
    end
  end

  private
    attr_reader :trip
end
