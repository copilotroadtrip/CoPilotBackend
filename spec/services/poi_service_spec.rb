require 'rails_helper'

describe 'POI Service Spec' do
  it 'returns array of POI, and array of Leg information along route' do
    VCR.use_cassette("requests/post_trips/ogden") do
      origin = 'Denver,CO'
      destination = 'Ogden,UT'

      gs = GoogleMapsService.new(origin, destination)
      route_coordinates = gs.route_coordinates

      ps = PoiService.new(route_coordinates)

      expect(ps.places).to be_an(Array)
      expect(ps.legs).to be_an(Array)
      expect(ps.legs.length).to be(ps.places.length - 1)
    end
  end
end
