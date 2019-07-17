class PoiInfo
  attr_reader :poi, :start_coord, :end_coord
  def initialize(poi, coord)
    @poi = poi
    raise "Not Coordinate Object" if coord.class != Coordinate
    @start_coord = coord
    @end_coord = coord
  end

  def update_end(coord)
    @end_coord = coord
  end
end
