class InitialTripFacade
  attr_reader :origin, :destination, :trip

  def initialize(trip_params)
    @origin = trip_params[:origin]
    @destination = trip_params[:destination]
    @trip = Trip.create

    request_trip_data_from_microservice
  end

  def request_trip_data_from_microservice
    @trip.steps = _directions.steps.to_json
    @trip.save

    TripWorker.perform_async(@trip.id)
  end

  def response
    return {
      data: {
        trip_token: trip.token,
        places: [ origin_data, destination_data ],
        legs: [ leg_data.json_with_id(1) ]
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
    @_leg_data ||= LegInfo.new(_directions.leg_info)
  end


  private

    def _directions
      @_directions  ||= GoogleMapsService.new(origin, destination)
    end

end
