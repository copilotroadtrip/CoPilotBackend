class TripFacade
  attr_reader :origin, :destination

  def initialize(trip_params)
    @origin = trip_params[:origin]
    @destination = trip_params[:destination]
  end

  def response
    {
      data: {
        places: [
          name: origin,
          population: origin_population,
          weather: 
        ]
      }
    }
  end

  private

    def _google_maps_service
      @_google_maps_service  ||= GoogleMapsService.new(trip_params[:origin], trip_params[:destination])
    end

    def _weather_service_origin
      @_weather_service_origin ||= DarkSkyService.new(gms.origin_lat, gms.origin_long)
    end

    def _weather_service_destination
      @_weather_service_destination ||= DarkSkyService.new(gms.destination_lat, gms.destination_long)
    end
end
