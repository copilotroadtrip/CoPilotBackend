class TripFacade
  attr_reader :origin, :destination

  def initialize(trip_params)
    @origin = trip_params[:origin]
    @destination = trip_params[:destination]
  end

  def response
    origin = _poi_service.places[0]
    origin_weather = ForecastSerializer.new(_weather_service.get(origin.center.lat, origin.center.lng)).currently
    places = [PoiSerializer.new(origin, origin_weather).to_json]
    legs = []
    running_time = 0.0
    _poi_service.places[1..-1].zip(_poi_service.legs).each_with_index do |(place, leg), index|
      running_time += leg.time
      place_weather = ForecastSerializer.new(_weather_service.get(place.center.lat, place.center.lng)).hourly_in(running_time.round)

      places << PoiSerializer.new(place, place_weather).to_json
      legs << leg.json_with_id(index)
    end

    return {
            data: {
                places: places,
                legs: legs
              }
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
