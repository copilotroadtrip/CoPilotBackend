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
        places: [origin_data, destination_data],
        legs: [legs_data]
      }
    }
  end

  def origin_data
    {
       "location": {
           "lat": _directions.start_lat,
           "lng": _directions.start_lng
       },
       "name": _directions.start_address,
       "state": Poi.poi_at_location(_directions.start_lat, _directions.start_lng)[0].state,
       "population": Poi.population_at_location(_directions.start_lat, _directions.start_lng),
       "weather": origin_weather
   }
  end

  def origin_weather
    weather_data = _weather_service.get(_directions.start_lat, _directions.start_lng)

    ForecastSerializer.new(weather_data).currently
  end

  def destination_data
    {
       "location": {
           "lat": _directions.end_lat,
           "lng": _directions.end_lng
       },
       "name": _directions.end_address,
       "state": Poi.poi_at_location(_directions.end_lat, _directions.end_lng)[0].state,
       "population": Poi.population_at_location(_directions.end_lat, _directions.end_lng),
       "weather": destination_weather
   }
  end

  def destination_weather
    weather_data = _weather_service.get(_directions.end_lat, _directions.end_lng)
    duration_hours = _directions.duration_hours
    # Get weather of destination at X hours from now
    ForecastSerializer.new(weather_data).hourly_in(duration_hours.round)
  end

  def legs_data
    {
      "distance": _directions.distance_text,
      "duration_in_hours": _directions.duration_hours
    }
  end

  private

    def _poi_service
      @_poi_service ||= PoiService.new(_directions.steps)
    end

    def _directions
      @_directions  ||= GoogleMapsService.new(origin, destination)
    end

    def _weather_service
      @_weather_service_origin ||= DarkSkyService.new()
    end
end
