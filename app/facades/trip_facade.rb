class TripFacade
  attr_reader :origin, :destination, :trip, :steps

  def initialize(trip_params)
    @origin = trip_params[:origin]
    @destination = trip_params[:destination]
    @trip = Trip.create
    @steps = _directions.steps

    # Add SidekiqWorker job here to build POIs and legs of trip
    # The worker will need the trip id/token and Google directions payload
    # Otherwise it will need to make a second Google API request

    # @matt -- The below does everything -- parsing and loading into the db...
    # but it blocks "response" from being immediately returned

    # TripService.new(_directions.steps, @trip.id)
  end

  def response
    return {
      data: {
        trip_token: trip.token,
        places: [ origin_data, destination_data ],
        legs: [ leg_data.to_json ]
      }
    }
  end

  def origin_data

    origin_poi  = Poi.poi_at_location(_directions.start_lat, _directions.start_lng)
                          .order(population: "DESC")
                          .first

    PoiSerializer.new(origin_poi).to_json_with_timing(0)
  end


  def destination_data

    destination_poi  = Poi.poi_at_location(_directions.end_lat, _directions.end_lng)
                          .order(population: "DESC")
                          .first

    PoiSerializer.new(destination_poi).to_json_with_timing(leg_data.time.round)
  end

  def leg_data
    LegSerializer.from_json(_directions.leg_info, @trip.id, 1)
  end


  private

    def _directions
      @_directions  ||= GoogleMapsService.new(origin, destination)
    end

end
