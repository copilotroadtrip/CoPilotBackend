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












  # def nested_pois
  #   @_nested_pois ||= coordinates.map do |coord_pair|
  #     poi_list = Poi.poi_at_location(*coord_pair)
  #     if poi_list == []
  #       nil
  #     else
  #       poi_list
  #     end
  #   end.compact
  # end
  #
  # def build_initial_poi_list
  #   @unique_poi = nested_pois.flatten.uniq
  # end
  #
  # def parse_nested
  #   pois = []
  #   discards = []
  #   unique_poi_by_pop = nested_pois.flatten.uniq.sort_by{|poi| poi.population}.reverse!
  #
  #   unique_poi_by_pop.each do |poi|
  #     unless poi_in_list?(poi, discards)
  #       nests = nested_pois.select do |nest_poi|
  #         poi_in_list?(poi, nest_poi)
  #       end
  #       # binding.pry
  #       if nests.all? { |nest| poi.population == nest.max_by{ |poi| poi.population}.population}
  #         pois << poi
  #       else
  #         discards << poi
  #       end
  #     end
  #   end
  #
  #   return pois
  # end
  #
  # def build_legs
  #   subset_poi_list = parse_nested
  #   poi_info = []
  #   previous_coords = []
  #   coordinates.each do |coord_pair|
  #     poi_list = Poi.poi_at_location(*coord_pair)
  #
  #     if last_pair == []
  #       intersect = subset_poi_list & poi_list
  #       if intersect.length == 0
  #         poi = poi_list.max_by{ |p| p.population}
  #       elsif intersect.length == 1
  #         poi = intersect[0]
  #       else
  #         poi = intersect.max_by{ |p| p.population}
  #       end
  #       poi_info << {poi: poi, first_coord: coord_pair, last_coord: coord_pair}
  #     else
  #       intersect = subset_poi_list & poi_list
  #       intersect.each do |poi|
  #         info = poi_info.find{ |p_i| p_i[:poi] == poi}
  #
  #         if info
  #           info[:last_coord] = coord_pair
  #         else
  #           poi_info << {poi: poi, first_coord: coord_pair, last_coord: coord_pair}
  #         end
  #
  #     end
  #
  # end
  #
  # def poi_in_list?(target_poi, poi_list)
  #   poi_list.any?{ |poi| poi == target_poi}
  # end
  #   # pois = []
  #   # discards = []
  #   # legs = []
  #   # last_pair = []
  #   # running_dist = 0.0
  #   # coordinates.each do |coord_pair|
  #   #   poi_list = Poi.poi_at_location(coord_pair)
  #   #
  #   #   if last_pair == []
  #   #     poi = poi_list.max_by{ |poi| poi.population}
  #   #
  #   #     pois << {poi: poi, first_coord: coord_pair}
  #   #   else
  #   #     running_dist += dist_between_points(last_pair, coord_pair)
  #   #
  #   #   end
  #   #
  #   #   last_pair = coord_pair
  #   # end
  #
  #
  # def other_poi(keeper_poi, poi_list)
  #   poi_list.select{ |poi| poi != keeper_poi}
  # end
  #
  # def dist_between_points(lat_lng1, lat_lng2)
  #   lat_diff = lat_lng1[0] - lat_lng2[0]
  #   lng_diff = lat_lng1[1] - lat_lng2[1]
  #
  #   lat_dist = 69.1 * lat_diff.abs
  #   mid_lat = lat_lng1[0] - (lat_diff / 2.0)
  #
  #   one_lng_degree_dist = 69.172 * Math.cos(radians(mid_lat))
  #   lng_dist = one_lng_degree_dist * lng_diff
  #
  #   return ((lat_dist ** 2) + (lng_dist ** 2)) ** 0.5
  # end
  #
  # def radians(degrees)
  #   degrees * Math::PI / 180
  # end
