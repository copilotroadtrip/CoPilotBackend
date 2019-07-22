class TripService

  def initialize(steps, trip_id)
    @trip = Trip.find(trip_id)
    @poi_collection = PoiCollection.new
    @coord_collection = CoordCollection.new(@trip.id)

    # Should save coord_collection info (trip_id and max_index) to trip table
    # Will allow for refresh and teardown

    parse_steps(steps)

    @places = @poi_collection.ordered_pois
    save_places

    save_legs

    set_trip_to_ready
  end

  def parse_steps(steps)
    coordinate_index = 0
    steps.each do |step|
      step = Step.new(step)
      coordinate_index = parse_step(step, coordinate_index)
    end
  end

  def parse_step(step, coordinate_index)
    step.coordinates.each_with_index do |coordinate, step_c_index|
      if step_c_index != 0 # First coordinate of each step is a repeat
        point_pois = Poi.poi_at_location(*coordinate.to_a)
        @poi_collection.update(point_pois, coordinate_index) if point_pois

        @coord_collection.update( coordinate, coordinate_index, step )
        coordinate_index += 1
      end
    end

    coordinate_index
  end

  def save_places
    @places.each_with_index do |poi_info, index|
      @trip.trip_pois.create(poi: poi_info.poi, sequence_number: index)
    end
  end

  def save_legs
    sequence_number = 1
    @places.each_cons(2) do |(start_poi, end_poi)|
      segment = [ start_poi.start_coord, end_poi.start_coord ]
      segment_info = @coord_collection.segment_info(*segment)
      @trip.trip_legs.create( sequence_number: sequence_number, duration:segment_info[:duration], distance:segment_info[:distance])
      sequence_number += 1
    end
  end

  def set_trip_to_ready
    @trip.status = "ready"
    @trip.save
  end

end
