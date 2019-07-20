class PoiSerializer
  attr_reader :name, :population, :weather, :id, :state, :location

  def initialize(poi)
    # binding.pry
    @id = poi.id
    @location = poi.center
    @name = poi.name
    @population = poi.population
    @state = poi.state
    @weather = get_forecast
  end

  def to_json
    {
      id: id,
      location: location,
      name: name,
      state: state,
      population: population,
      weather: weather,
    }
  end

  def to_json_with_timing(hours_from_now)
    forecast = ForecastSerializer.new(to_json[:weather]).hourly_in(hours_from_now)
    to_json.merge({weather: forecast})
  end

  private

  def get_forecast
    _weather_service.get(location)
  end

  def _weather_service
    @_weather_service ||= DarkSkyService.new
  end
end
