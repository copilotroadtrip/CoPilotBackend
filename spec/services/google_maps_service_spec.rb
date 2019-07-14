require 'rails_helper'

describe 'Google Maps Service Spec' do
  it 'returns array of longitude latitude points along route' do
   VCR.use_cassette("services/google_maps/directions") do
      origin = 'Denver,CO'
      destination = 'Seattle,WA'

      gs = GoogleMapsService.new(origin, destination)
      route_coordinates = gs.route_coordinates

      expect(route_coordinates).to         be_an(Array)
      expect(route_coordinates.length).to  eq(41778)

      expect(route_coordinates.first).to   eq([39.74116, -104.98791])
      expect(route_coordinates.last).to    eq([47.60637999999997, -122.33223000000001])
    end
  end
end
