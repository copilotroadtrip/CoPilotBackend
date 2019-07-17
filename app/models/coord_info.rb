class CoordInfo
  attr_reader :coord, :step_index, :meter_distance, :travel_time

  def initialize(coord, prev_coord, step_info, step_index)
    @coord = coord
    @step_index = step_index
    @meter_distance = find_meter_distance(coord, prev_coord)
    @travel_time = find_travel_time(step_info)
  end

  private

  def find_travel_time(step_info)
    meter_distance / step_info.speed
  end

  def find_meter_distance(coord1, coord2)
    return 0 if coord2 == []
    # Using haversine formula
    # https://en.wikipedia.org/wiki/Haversine_formula
    earth_radius = 6378.137
    lat1 = radians(coord1.lat)
    lat2 = radians(coord2.lat)
    lng_diff = radians(coord1.lng) - radians(coord2.lng)

    radicand = (
      ( Math.sin((lat1-lat2)/2) ** 2) +
        Math.cos(lat1) *
        Math.cos(lat2) *
      ( Math.sin(lng_diff / 2) **2 )
    )

    2 * earth_radius * Math.asin( Math.sqrt( radicand ) ) * 1000

  end

  def radians(degrees)
    degrees * Math::PI / 180
  end
end


#
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
