require 'rails_helper'

describe 'POI Service Spec' do
  it 'returns array of POI, and array of Leg information along route' do
    VCR.use_cassette("requests/post_trips/ogden") do
      origin = 'Denver,CO'
      destination = 'Ogden,UT'

      options_hash = {col_sep: ",", headers: true,
        header_converters: :symbol, converters: :numeric}
      pois = CSV.open('spec/requests/api/v1/ogden_poi.csv', options_hash)

      poi_hashes = pois.map{ |row| row.to_hash }

      poi_hashes.each do |hash|
        create(:poi,
            ne_latitude: hash[:nelat],
            ne_longitude: hash[:nelng],
            sw_latitude: hash[:swlat],
            sw_longitude: hash[:swlng],
            name: hash[:name],
            population: hash[:population],
            state: hash[:state],
            land_area: hash[:land_area],
            total_area: hash[:total_area])

      end

      gs = GoogleMapsService.new(origin, destination)
      steps = gs.steps

      ps = PoiService.new(steps)
      # ps.test
      expect(ps.places).to be_an(Array)
      expect(ps.legs).to be_an(Array)
      expect(ps.legs.length).to be(ps.places.length - 1)
    end
  end
end
