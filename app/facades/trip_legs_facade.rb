class TripLegsFacade
  def initialize(trip)
    @trip = trip
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

  private
    attr_reader :trip
end