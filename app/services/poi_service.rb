class PoiService

  # Eventually this should have the encoded coordinate string passed in

  attr_reader :steps, :poi_info, :coord_info, :nested_poi, :places, :legs

  def initialize(steps)
    @steps = steps

    @poi_info, @coord_info, @nested_poi = traverse_steps
    @places = filter_poi
    @legs = build_legs
  end

  def build_legs
    legs = []
    (1..(places.length-1)).each do |index|
      poi_start = find_poi_info(places[index]).start_coord
      prev_poi_start = find_poi_info(places[(index -1)]).start_coord
      seconds = inter_coord_time(poi_start, prev_poi_start)
      meters = inter_coord_dist(poi_start, prev_poi_start)
      legs << LegInfo.new(seconds, meters)
    end

    return legs
  end

  def find_poi_info(poi)
    poi_info.find{|info| info.poi == poi}
  end

  def inter_coord_dist(coord1, coord2)
    coord_subset = find_coord_subset(coord1, coord2)

    coord_subset.sum{ |coord_info| coord_info.meter_distance}
  end

  def inter_coord_time(coord1, coord2)
    coord_subset = find_coord_subset(coord1, coord2)

    coord_subset.sum{ |coord_info| coord_info.travel_time}
  end

  def find_coord_subset(coord1, coord2)
    c1_idx = coord_info.index{ |c| c.coord == coord1}
    c2_idx = coord_info.index{ |c| c.coord == coord2}
    start, last = [c1_idx, c2_idx].sort
    coord_info[(start+1)..last]
  end

  def filter_poi
    unique_poi = nested_poi.flatten.uniq
    major_poi = remove_overlapped(unique_poi)

    major_poi = sort_by_appearance(major_poi)
    # Add more filters
    major_poi
  end

  def sort_by_appearance(major_poi)
    major_poi.sort_by do |poi|
      info = find_poi_info(poi)
      index = coord_info.index{ |c| c.coord == info.start_coord}
      # puts index
      index
    end
  end

  def remove_overlapped(unique_poi)
    major_poi = []
    poi_by_pop = unique_poi.sort_by{ |poi| poi.population}.reverse!

    poi_by_pop.each do |poi|
      poi_lists = all_including_poi(poi)
      if always_largest(poi, poi_lists)
        major_poi << poi
      end
    end

    major_poi
  end

  def always_largest(poi, poi_nests)
    poi_nests.all?{ |poi_list| poi.population == max_population(poi_list)}
  end

  def max_population(poi_list)
    poi_list.max_by{ |poi| poi.population}.population
  end

  def all_including_poi(poi)
    nested_poi.select{ |poi_list| poi_in_list?(poi, poi_list)}
  end

  def poi_in_list?(target_poi, poi_list)
    poi_list.any?{ |poi| poi == target_poi}
  end

  def traverse_steps

    ### This needs to be fixed: correct step info not associated with each segment
    ### Also look into "normalizing" step speeds / distances with returned info

    poi_info = []
    coord_info = []
    nested_poi = []

    step_info = StepInfo.new(steps[0])

    steps.each_with_index do |step, step_index|

      coordinates = step_coordinates(step)

      prev_coord = []

      coordinates.each_with_index do |raw_coord, segment_index|
        if segment_index == 1
          step_info = StepInfo.new(step)
        end

        coord = Coordinate.new(raw_coord)
        poi_list = Poi.poi_at_location(coord.lat, coord.lng)
        nested_poi = update_nested_poi(poi_list, nested_poi)
        poi_info = update_poi_info(poi_list, poi_info, coord)
        coord_info = update_coord_info(coord, prev_coord, step_info, step_index, coord_info)

        prev_coord = coord
      end
    end

    return [poi_info, coord_info, nested_poi]
  end


  def update_coord_info(coord, prev_coord, step_info, step_index, coord_info)
    coord_info << CoordInfo.new(coord, prev_coord, step_info, step_index)
    coord_info
  end


  def update_nested_poi(poi_list, nested_poi)
    if poi_list.length != 0
      nested_poi << poi_list
    end

    return nested_poi
  end

  def update_poi_info(poi_list, poi_info, coord)
    poi_list.each do |poi|
      info = poi_info.find{ |i| i.poi == poi}
      if info
        info.update_end(coord)
      else
        poi_info << PoiInfo.new(poi, coord)
      end
    end

    return poi_info
  end

  def step_coordinates(step)
    Polylines::Decoder.decode_polyline(step['polyline']['points'])
  end


end
