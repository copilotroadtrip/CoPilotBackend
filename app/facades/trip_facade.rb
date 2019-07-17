class TripFacade
  attr_reader :origin, :destination

  def initialize(trip_params)
    @origin = trip_params[:origin]
    @destination = trip_params[:destination]
  end

  def response
    # Origin / destination names from Google Maps
    start_address = _google_maps_service.start_address
    end_address = _google_maps_service.end_address

    # Get long/lat of origin and destination
    origin_lat = _google_maps_service.origin_lat
    origin_lng = _google_maps_service.origin_lng
    destination_lat = _google_maps_service.destination_lat
    destination_lng = _google_maps_service.destination_lng

    # Get miles and time between origin and destination
    distance_text = _google_maps_service.distance_text
    duration_hours = _google_maps_service.duration_hours

    # Get population or origin and destination
    origin_population = Poi.population_at_location(origin_lat, origin_lng)
    destination_population = Poi.population_at_location(destination_lat, destination_lng)

    # Get weather of origin currently
    origin_weather = ForecastSerializer.new(_weather_service.get(origin_lat, origin_lng)).currently

    # Get weather of destination at X hours from now
    destination_weather = ForecastSerializer.new(_weather_service.get(destination_lat, destination_lng)).hourly_in(duration_hours.round)

    return {
            data: {
                places: [
                    {
                        "name": start_address,
                        "population": origin_population,
                        "weather": origin_weather,
                    },
                    {
                        "name": end_address,
                        "population": destination_population,
                        "weather": destination_weather
                    }
                ],
                legs: [
                    {
                        "distance": distance_text,
                        "duration_in_hours": duration_hours
                    }
                ]
              }
            }
  end

  private

    def _google_maps_service
      @_google_maps_service  ||= GoogleMapsService.new(origin, destination)
    end

    def _weather_service
      @_weather_service_origin ||= DarkSkyService.new()
    end


end
