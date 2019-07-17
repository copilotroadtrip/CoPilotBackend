class PoiSerializer
  attr_reader :name, :population, :weather, :id

  def initialize(poi, forecast)
    @id = poi.id
    @name = poi.name
    @population = poi.population
    @weather = forecast
  end

  def to_json
    {
      id: @id,
      name: @name,
      population: @population,
      weather: @weather,
    }
  end
end
