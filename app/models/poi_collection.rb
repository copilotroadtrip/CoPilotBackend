class PoiCollection
  def initialize()
    @pois = {}
    @discarded = []
  end


  def update(poi_list, coordinate_index)
    sorter = PoiSorter.new(poi_list)
    remove_discarded(sorter.discard)

    poi = sorter.keep
    return if @discarded.index(poi)

    if @pois.keys.include?(poi)
      @pois[poi].update(coordinate_index)
    else
      @pois[poi] = PoiInfo.new(poi, coordinate_index)
    end

  end

  def remove_discarded(discard)
    @discarded.push(discard)
    @discarded = @discarded.uniq

    discard.each do |poi|
      @pois.delete(poi)
    end
  end

  def index(poi)
    if @pois.keys.include?(poi)
      return @pois[poi].start_coord
    else
      return nil
    end
  end

  def pois
    return @pois.keys
  end

  def ordered_pois
    @pois.values.sort_by{|poi_info| index(poi_info.poi)}
  end
end
