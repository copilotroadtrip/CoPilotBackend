class Step
  attr_reader :dist, :time, :coordinates, :coordinate_count

  def initialize(step)
    @dist = step_dist(step)
    @time = step_time(step)
    # @speed = step_speed(step)
    @polyline_string = step['polyline']['points']
    @coordinates = all_coordinates.map{ |coord| Coordinate.new(*coord)}
    @coordinate_count = @coordinates.length
    # @pois = all_pois
  end

  def to_json
    {
      distance: @dist,
      duration: @time,
      coordinate_count: @coordinate_count
    }
  end

  private

  # def all_pois
  #   collection = PoiCollection.new
  #   @coordinates.each_with_index do |coordinate, index|
  #     point_pois = Poi.poi_at_location(*coordinate.to_a)
  #     collection.update(point_pois, index)
  #   end
  #   collection
  # end

  def all_coordinates
    Polylines::Decoder.decode_polyline(@polyline_string)
  end


  def step_dist(step)
    step['distance']['value']
  end

  def step_time(step)
    step['duration']['value']
  end
end

# def step_speed(step)
#   step_dist(step) / step_time(step).to_f
# end
