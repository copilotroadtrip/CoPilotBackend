class TripFacade
  attr_reader :origin, :destination, :trip

  def initialize(trip_params)
    @origin = trip_params[:origin]
    @destination = trip_params[:destination]
    @trip = Trip.create

    # Add SidekiqWorker job here to build POIs and legs of trip
    # The worker will need the trip id/token and Google directions payload
    # Otherwise it will need to make a second Google API request
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

    # def _poi_service
    #   @_poi_service ||= PoiService.new(_directions.steps)
    # end

    def _directions
      @_directions  ||= GoogleMapsService.new(origin, destination)
    end

end
